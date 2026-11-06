// SPDX-License-Identifier: GPL-3.0-or-later
//
// mic-capture.js: Tesla browser (cabin) microphone -> Tesla Android (wss://<host>/sockets/mic).
//
// Opt-in and passive: nothing happens unless the device runs tesla-android-mic-bridge
// (persist.tesla-android.browser_mic.is_enabled=1). The page checks the socket on load and,
// while it does not answer, again on a tap with a growing pause (10 s up to 10 min). When the
// bridge answers, the first tap asks for the microphone (the browser needs a user gesture) and
// streams PCM s16le mono 48 kHz in 20 ms frames. Echo cancellation, noise suppression and AGC are
// requested from the browser. A small dot bottom-left shows the state (grey: available, amber:
// waiting for permission or connecting, red: streaming). Without the bridge or the getUserMedia
// API the page behaves exactly as before.
(function () {
  "use strict";
  if (window.__taMic) return;
  const state = { ws: null, ctx: null, stream: null, node: null, started: false, gen: 0,
                  available: false, probing: false, lastProbe: 0, probeWait: 10000,
                  retry: null, fails: 0, status: "off" };
  window.__taMic = state;
  const RATE = 48000, FRAME = 960;
  const micUrl = () => (location.protocol === "https:" ? "wss://" : "ws://") + location.host + "/sockets/mic";

  const dot = document.createElement("div");
  dot.style.cssText = "display:none;position:fixed;left:6px;bottom:6px;width:10px;height:10px;border-radius:5px;z-index:2147483647;pointer-events:none;background:#888;opacity:.7";
  const setStatus = (s) => {
    state.status = s;
    dot.style.background = { off: "#888", wait: "#e5a50a", active: "#e01b24", denied: "#333", error: "#333" }[s] || "#888";
  };
  const log = (...a) => console.log("[ta-mic]", ...a);

  const workletSrc = `
    class TaMic extends AudioWorkletProcessor {
      constructor(o) { super(); this.ratio = o.processorOptions.rate / ${RATE}; this.pos = 0; this.buf = new Int16Array(${FRAME}); this.n = 0; }
      process(inputs) {
        const ch = inputs[0]; if (!ch || !ch.length) return true;
        const len = ch[0].length;
        for (let i = 0; i < len; i++) {
          let s = 0; for (let c = 0; c < ch.length; c++) s += ch[c][i]; s /= ch.length;
          this.pos += 1;
          while (this.pos >= this.ratio) {           // simple decimation/hold resampler to 48 kHz
            this.pos -= this.ratio;
            const v = Math.max(-1, Math.min(1, s));
            this.buf[this.n++] = v < 0 ? v * 0x8000 : v * 0x7fff;
            if (this.n === ${FRAME}) { this.port.postMessage(this.buf.buffer, [this.buf.buffer]); this.buf = new Int16Array(${FRAME}); this.n = 0; }
          }
        }
        return true;
      }
    }
    registerProcessor("ta-mic", TaMic);`;

  // Is the bridge running? One short-lived socket. After a miss the next check waits twice as
  // long (10 s, 20 s, ... 10 min), so a device without the feature sees only a few requests.
  function probe() {
    if (state.available || state.probing || Date.now() - state.lastProbe < state.probeWait) return;
    if (!window.WebSocket) return;
    state.probing = true;
    state.lastProbe = Date.now();
    let ws;
    try { ws = new WebSocket(micUrl()); } catch (_) { state.probing = false; return; }
    ws.onopen = () => {
      state.available = true;
      state.probeWait = 10000;
      dot.style.display = "block";
      setStatus("off");
      log("bridge available, tap to start the microphone");
      ws.close();
    };
    ws.onerror = () => {};
    ws.onclose = () => {
      state.probing = false;
      if (!state.available) state.probeWait = Math.min(state.probeWait * 2, 600000);
    };
  }

  // Streaming socket. Reconnects after 2 s, longer after failures; after 5 attempts in a row that
  // never connect, the bridge is treated as gone and the microphone is released.
  function connect(gen) {
    if (!state.started || gen !== state.gen) return;
    const ws = new WebSocket(micUrl());
    ws.binaryType = "arraybuffer";
    let opened = false;
    ws.onopen = () => {
      opened = true;
      state.fails = 0;
      setStatus("active");
      log("ws open");
      ws.send('{"type":"mic","state":"start"}');
    };
    ws.onclose = () => {
      if (state.ws === ws) state.ws = null;
      if (!state.started || gen !== state.gen) return;
      if (!opened && ++state.fails >= 5) {
        log("bridge gone, microphone released");
        stop();
        state.available = false;
        dot.style.display = "none";
        return;
      }
      setStatus("wait");
      const delay = Math.min(2000 * Math.pow(2, state.fails), 30000);
      state.retry = setTimeout(() => { state.retry = null; connect(gen); }, delay);
    };
    ws.onerror = () => {};
    state.ws = ws;
  }

  async function start() {
    if (state.started) return;
    state.started = true;
    state.fails = 0;
    const gen = ++state.gen;
    const cancelled = () => gen !== state.gen;   // stop() was called while we were waiting
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia || !window.AudioWorkletNode) { log("unsupported"); setStatus("error"); return; }
    setStatus("wait");
    let stream;
    try {
      stream = await navigator.mediaDevices.getUserMedia({ audio: { echoCancellation: true, noiseSuppression: true, autoGainControl: true, channelCount: 1 } });
    } catch (e) {
      if (!cancelled()) { log("getUserMedia denied", e && e.name); setStatus("denied"); }
      return;
    }
    if (cancelled()) { stream.getTracks().forEach((t) => t.stop()); return; }
    state.stream = stream;
    try {
      const ctx = state.ctx = new AudioContext({ latencyHint: "interactive" });
      await ctx.audioWorklet.addModule(URL.createObjectURL(new Blob([workletSrc], { type: "application/javascript" })));
      if (cancelled()) return;                     // stop() already released ctx and stream
      const src = ctx.createMediaStreamSource(stream);
      state.node = new AudioWorkletNode(ctx, "ta-mic", { processorOptions: { rate: ctx.sampleRate } });
      state.node.port.onmessage = (e) => {
        const ws = state.ws;
        if (ws && ws.readyState === 1 && ws.bufferedAmount < 19200) ws.send(e.data); // drop when >200 ms queued
      };
      src.connect(state.node);
      const sink = ctx.createGain(); sink.gain.value = 0;       // keep the graph pulling, silent
      state.node.connect(sink).connect(ctx.destination);
      if (ctx.state !== "running") await ctx.resume();
      if (cancelled()) return;
      connect(gen);
      log("capture running at", ctx.sampleRate, "Hz");
    } catch (e) {
      log("setup failed", e);
      if (!cancelled()) { state.gen++; release(); setStatus("error"); }   // no retry until reload
    }
  }

  function release() {
    if (state.retry) { clearTimeout(state.retry); state.retry = null; }
    const ws = state.ws;
    state.ws = null;
    try { ws && ws.readyState === 1 && ws.send('{"type":"mic","state":"stop"}'); } catch (_) {}
    try { ws && ws.close(); } catch (_) {}
    try { state.stream && state.stream.getTracks().forEach((t) => t.stop()); } catch (_) {}
    try { state.ctx && state.ctx.close(); } catch (_) {}
    state.ctx = state.stream = state.node = null;
  }

  function stop() {
    state.started = false;
    state.gen++;
    release();
    setStatus("off");
  }
  window.taMicStart = start;
  window.taMicStop = stop;

  const onGesture = () => { if (state.available) start(); else probe(); };
  window.addEventListener("pointerdown", onGesture, { capture: true, passive: true });
  window.addEventListener("pagehide", stop);
  const mount = () => { if (document.body) document.body.appendChild(dot); probe(); };
  if (document.body) mount(); else document.addEventListener("DOMContentLoaded", mount);
})();
