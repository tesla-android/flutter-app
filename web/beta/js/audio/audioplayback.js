(() => {
  const MIME = 'audio/mp4; codecs="flac"';

  const MAX_QUEUE_BYTES     = 2 * 1024 * 1024;
  const DROP_ON_BYTES       = 1.6 * 1024 * 1024;
  const RESUME_ON_BYTES     = 0.8 * 1024 * 1024;

  const TRIM_INTERVAL_MS    = 5000;
  const KEEP_TAIL_SEC       = 0.20;
  const MAX_LATENCY_SEC     = 1.0;
  const HARD_JUMP_SEC       = 0.10;

  let isAudioEnabled = true;
  let audioVolume = 1.0;

  let audioEl = null;
  let mediaSource = null;
  let sourceBuffer = null;

  let worker = null;
  let queue = [];
  let queueBytes = 0;
  let appending = false;
  let dropRequested = false;

  let started = false;
  let trimmingTimer = null;
  let recovering = false;

  let audioCtx = null;

  function log(){ /* console.log.apply(console, ['[Audio]', ...arguments]); */ }

  window.setAudioEnabled = function(enabled) {
    isAudioEnabled = (typeof enabled === 'boolean') ? enabled : (enabled !== 'false');
  };
  window.setAudioVolume = function(volume) {
    audioVolume = Math.max(0, Math.min(1, Number(volume)));
    if (audioEl) audioEl.volume = audioVolume;
  };
  window.getAudioEnabled = function() { return isAudioEnabled; };

  window.primeAudioFromGesture = function primeAudioFromGesture() {
    try {
      ensureAudioEl();
      resumeAudioContextIfNeeded();
      audioEl.play().catch(()=>{});
    } catch(_) {}
  };

  window.startAudioPlayback = function () {
    if (started) return;
    started = true;
    startAudio();
  };

  window.stopAudioPlayback = function () {
    started = false;
    stopAudio();
  };

  function ensureAudioEl() {
    if (audioEl) return audioEl;

    audioEl = document.createElement('audio');
    audioEl.playsInline = true;
    audioEl.autoplay = true;
    audioEl.controls = false;
    audioEl.muted = false;
    audioEl.crossOrigin = "anonymous";
    audioEl.volume = audioVolume;
    document.body.appendChild(audioEl);

    window.__liveAudioEl = audioEl;
    try { window.dispatchEvent(new CustomEvent('audio-el-created')); } catch {}

    audioEl.addEventListener('error', () => {
      recoverPipelineSoon();
    });

    return audioEl;
  }

  function ensureAudioContext() {
    if (audioCtx) return audioCtx;
    const Ctx = window.AudioContext || window.webkitAudioContext;
    if (!Ctx) return null;
    audioCtx = new Ctx();
    return audioCtx;
  }

  function resumeAudioContextIfNeeded() {
    const ctx = ensureAudioContext();
    if (ctx && ctx.state === 'suspended') {
      ctx.resume().catch(()=>{});
    }
  }

  function setupMSE() {
    mediaSource = new MediaSource();
    const el = ensureAudioEl();
    el.src = URL.createObjectURL(mediaSource);
    el.load();

    mediaSource.addEventListener('sourceopen', () => {
      try { mediaSource.duration = Infinity; } catch(_){}
      try {
        sourceBuffer = mediaSource.addSourceBuffer(MIME);
        sourceBuffer.mode = 'sequence';

        sourceBuffer.addEventListener('updateend', () => {
          processQueue();
          maybeTrimOld();
          maybeReduceLatency();
        });
        sourceBuffer.addEventListener('error', (e) => {
          log('SourceBuffer error', e);
          recoverPipelineSoon();
        });
      } catch (e) {
        log('addSourceBuffer failed', e);
        recoverPipelineSoon();
        return;
      }

      if (trimmingTimer) clearInterval(trimmingTimer);
      trimmingTimer = setInterval(() => {
        maybeTrimOld();
        maybeReduceLatency();
      }, TRIM_INTERVAL_MS);
    });

    mediaSource.addEventListener('sourceended', () => log('MediaSource ended'));
    mediaSource.addEventListener('sourceclose', () => log('MediaSource closed'));
  }

  function destroyMSE() {
    try {
      if (sourceBuffer) {
        sourceBuffer.onupdateend = sourceBuffer.onerror = null;
        if (mediaSource && mediaSource.readyState === 'open') {
          try { sourceBuffer.abort(); } catch {}
          try { mediaSource.removeSourceBuffer(sourceBuffer); } catch {}
        }
      }
    } catch {}
    sourceBuffer = null;

    try {
      if (mediaSource) {
        mediaSource.onsourceopen = mediaSource.onsourceended = mediaSource.onsourceclose = null;
        if (mediaSource.readyState === 'open') {
          try { mediaSource.endOfStream(); } catch {}
        }
      }
    } catch {}
    mediaSource = null;

    try {
      if (audioEl) {
        audioEl.pause();
        audioEl.removeAttribute('src');
        audioEl.load();
      }
    } catch {}
  }

  function startWorker(url) {
    if (worker) { try { worker.terminate(); } catch {} worker = null; }
    worker = new Worker("./js/audio/audio-ws-worker.js");
    worker.onmessage = (e) => {
      const { type } = e.data || {};
      if (type === 'data') {
        const ab = e.data.buf;
        if (ab && ab.byteLength) enqueue(new Uint8Array(ab));
        processQueue();
      } else if (type === 'error') {
        log('WS worker error:', e.data.message);
      }
    };
    worker.postMessage({ type: 'start', url });
  }

  function stopWorker() {
    if (!worker) return;
    try { worker.postMessage({ type: 'stop' }); worker.terminate(); } catch {}
    worker = null;
  }

  function setWorkerDropMode(drop) {
    if (!worker) return;
    if (drop === dropRequested) return;
    dropRequested = drop;
    try { worker.postMessage({ type: 'drop', drop }); } catch {}
  }

  function enqueue(u8) {
    while (queueBytes + u8.byteLength > MAX_QUEUE_BYTES && queue.length) {
      const old = queue.shift();
      queueBytes -= old.byteLength;
    }
    if (u8.byteLength > MAX_QUEUE_BYTES) return;

    queue.push(u8);
    queueBytes += u8.byteLength;

    if (queueBytes >= DROP_ON_BYTES) setWorkerDropMode(true);
    else if (queueBytes <= RESUME_ON_BYTES) setWorkerDropMode(false);
  }

  function processQueue() {
    if (!sourceBuffer || sourceBuffer.updating || appending) return;
    if (queue.length === 0) return;
    appending = true;

    const seg = queue.shift();
    queueBytes -= seg.byteLength;

    try {
      sourceBuffer.appendBuffer(seg);
    } catch (e) {
      queue.unshift(seg);
      queueBytes += seg.byteLength;
      appending = false;
      log('appendBuffer failed:', e);
      recoverPipelineSoon();
      return;
    }
    appending = false;

    if (queueBytes <= RESUME_ON_BYTES) setWorkerDropMode(false);
  }

  function getBufferedRemain() {
    if (!sourceBuffer || !audioEl) return 0;
    const b = sourceBuffer.buffered;
    if (!b || b.length === 0) return 0;
    const end = b.end(b.length - 1);
    return Math.max(0, end - audioEl.currentTime);
  }

  function maybeTrimOld() {
    if (!sourceBuffer || sourceBuffer.updating || !audioEl) return;
    const b = sourceBuffer.buffered;
    if (!b || b.length === 0) return;

    const ct = audioEl.currentTime;
    if (ct <= 4.0) return;

    const start0 = b.start(0);
    const removeEnd = Math.max(ct - KEEP_TAIL_SEC, start0);
    if (removeEnd > start0 + 0.001) {
      try { sourceBuffer.remove(start0, removeEnd); } catch {}
    }
  }

  function maybeReduceLatency() {
    if (!sourceBuffer || sourceBuffer.updating || !audioEl) return;
    const remain = getBufferedRemain();
    if (remain > MAX_LATENCY_SEC) {
      const b = sourceBuffer.buffered;
      if (!b || b.length === 0) return;
      const end = b.end(b.length - 1);
      const target = Math.max(0, end - HARD_JUMP_SEC);
      try { audioEl.currentTime = target; } catch {}
    }
  }

  function recoverPipelineSoon() {
    if (recovering) return;
    recovering = true;
    setTimeout(() => {
      stopAudio();
      startAudio();
      recovering = false;
    }, 800);
  }

  function startAudio() {
    if (!isAudioEnabled) { log('audio disabled'); return; }
    if (!window.audioWebsocketUrl) { log('no audioWebsocketUrl'); return; }

    resumeAudioContextIfNeeded();
    setupMSE();
    startWorker(window.audioWebsocketUrl);

    setupMediaSession();

    ensureAudioEl().play().catch(()=>{});
  }

  function stopAudio() {
    if (trimmingTimer) { clearInterval(trimmingTimer); trimmingTimer = null; }
    stopWorker();
    destroyMSE();

    queue.length = 0;
    queueBytes = 0;
    setWorkerDropMode(false);
    appending = false;

    teardownMediaSession();
  }

  let mediaRotateTimer = null;
  function setupMediaSession() {
    if (!('mediaSession' in navigator)) return;
    try {
      navigator.mediaSession.metadata = new MediaMetadata({
        title: 'Lossless Audio - Tesla Android',
        artist: 'Live',
        album: 'TeslaAndroid'
      });
      navigator.mediaSession.setActionHandler('play',  () => { audioEl?.play();  navigator.mediaSession.playbackState = 'playing'; });
      navigator.mediaSession.setActionHandler('pause', () => { audioEl?.pause(); navigator.mediaSession.playbackState = 'paused';  });
      navigator.mediaSession.playbackState = 'playing';

      if (mediaRotateTimer) clearInterval(mediaRotateTimer);
      mediaRotateTimer = setInterval(() => {
        navigator.mediaSession.metadata = new MediaMetadata({
          title: 'Lossless Audio | Tesla Android',
          artist: 'Live',
          album: 'TeslaAndroid'
        });
      }, 60000);
    } catch(_) {}
  }

  function teardownMediaSession() {
    if (!('mediaSession' in navigator)) return;
    try {
      navigator.mediaSession.playbackState = 'none';
      if (mediaRotateTimer) { clearInterval(mediaRotateTimer); mediaRotateTimer = null; }
    } catch(_) {}
  }
})();
