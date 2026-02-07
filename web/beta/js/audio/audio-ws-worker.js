let ws = null;
let want = false;
let currentUrl = "";
let backoff = 1000;
const MAX_BACKOFF = 10000;

function connect() {
  if (!want || !currentUrl) return;

  try {
    ws = new WebSocket(currentUrl);
    ws.binaryType = "arraybuffer";

    ws.onopen = () => {
      backoff = 1000;
      postMessage({ type: "open" });
    };

    ws.onmessage = (ev) => {
      if (ev.data instanceof ArrayBuffer) {
        postMessage({ type: "data", buf: ev.data }, [ev.data]);
      } else if (ev.data instanceof Blob) {
        ev.data.arrayBuffer().then((ab) => {
          postMessage({ type: "data", buf: ab }, [ab]);
        }).catch((e) => {
          postMessage({ type: "error", message: e && e.message ? e.message : "blob->arrayBuffer failed" });
        });
      }
    };

    ws.onerror = () => {
      postMessage({ type: "error", message: "ws error" });
    };

    ws.onclose = () => {
      postMessage({ type: "close" });
      scheduleReconnect();
    };
  } catch (e) {
    postMessage({ type: "error", message: e && e.message ? e.message : "ws create failed" });
    scheduleReconnect();
  }
}

function scheduleReconnect() {
  if (!want) return;
  const delay = backoff;
  backoff = Math.min(MAX_BACKOFF, backoff * 2);
  setTimeout(connect, delay);
}

self.onmessage = (e) => {
  const { type, url } = e.data || {};
  if (type === "start" && url) {
    want = true;
    currentUrl = url;
    backoff = 1000;
    connect();
  } else if (type === "stop") {
    want = false;
    if (ws) {
      try { ws.close(); } catch {}
      ws = null;
    }
  }
};