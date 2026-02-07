var img = document.getElementById("image");
var canvas = document.getElementById("canvas");
img.style.display = "none";
canvas.style.display = "block";

function toSafeNumber(value, fallback) {
  var parsed = Number(value);
  if (Number.isFinite(parsed)) return Math.max(1, Math.round(parsed));
  return Math.max(1, Math.round(fallback));
}

function resolveInitialDisplayWidth() {
  var candidate = typeof displayWidth !== "undefined" ? displayWidth : window.displayWidth;
  return toSafeNumber(candidate, 1280);
}

function resolveInitialDisplayHeight() {
  var candidate = typeof displayHeight !== "undefined" ? displayHeight : window.displayHeight;
  return toSafeNumber(candidate, 720);
}

function resolveViewportSize() {
  return {
    width: toSafeNumber(canvas.clientWidth || window.innerWidth, window.innerWidth || 1),
    height: toSafeNumber(canvas.clientHeight || window.innerHeight, window.innerHeight || 1),
  };
}

function buildRuntimeConfig(overrides) {
  var viewport = resolveViewportSize();
  var config = overrides || {};
  return {
    displayWidth: toSafeNumber(config.displayWidth, resolveInitialDisplayWidth()),
    displayHeight: toSafeNumber(config.displayHeight, resolveInitialDisplayHeight()),
    windowWidth: toSafeNumber(config.windowWidth, viewport.width),
    windowHeight: toSafeNumber(config.windowHeight, viewport.height),
  };
}

function applyCanvasViewport(runtimeConfig) {
  canvas.style.width = String(runtimeConfig.windowWidth) + "px";
  canvas.style.height = String(runtimeConfig.windowHeight) + "px";
}

function readTextFromPath(path) {
  try {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", path, false);
    xhr.send();
    if (xhr.status === 0 || (xhr.status >= 200 && xhr.status < 300)) {
      return xhr.responseText;
    }
  } catch (_error) {
    // no-op
  }
  return null;
}

function createWorkerWithFileFallback(workerPath, options) {
  try {
    return new Worker(workerPath);
  } catch (primaryError) {
    if (window.location.protocol !== "file:") {
      throw primaryError;
    }

    var workerSource = readTextFromPath(workerPath);
    if (workerSource) {
      var dependencies = (options && options.dependencies) || [];
      if (dependencies.length > 0) {
        var dependencySources = [];
        for (var index = 0; index < dependencies.length; index += 1) {
          var dependencySource = readTextFromPath(dependencies[index]);
          if (!dependencySource) {
            throw primaryError;
          }
          dependencySources.push(dependencySource);
        }

        workerSource = workerSource.replace(/^\s*importScripts\([\s\S]*?\);\s*/m, "");
        workerSource = dependencySources.join("\n;\n") + "\n;\n" + workerSource;
      }

      var blobUrl = URL.createObjectURL(
        new Blob([workerSource], { type: "text/javascript" }),
      );
      var worker = new Worker(blobUrl);
      worker.__blobUrl = blobUrl;
      return worker;
    }

    var absoluteWorkerUrl = new URL(workerPath, window.location.href).href;
    var bootstrapSource = "importScripts(" + JSON.stringify(absoluteWorkerUrl) + ");";
    var bootstrapBlobUrl = URL.createObjectURL(
      new Blob([bootstrapSource], { type: "text/javascript" }),
    );
    var bootstrapWorker = new Worker(bootstrapBlobUrl);
    bootstrapWorker.__blobUrl = bootstrapBlobUrl;
    return bootstrapWorker;
  }
}

var worker = null;
try {
  worker = createWorkerWithFileFallback("./js/display/renderers/h264-broadway/h264BrodwayWorker.js", {
    dependencies: [
      "./js/display/renderers/h264-broadway/Decoder.js",
      "./js/display/renderers/h264-broadway/YUVCanvas.js",
    ],
  });
} catch (error) {
  console.error("Failed to initialize h264Brodway worker", error);
}
const offscreenCanvas = canvas.transferControlToOffscreen();
const initialRuntimeConfig = buildRuntimeConfig();

window.displayWidth = initialRuntimeConfig.displayWidth;
window.displayHeight = initialRuntimeConfig.displayHeight;
applyCanvasViewport(initialRuntimeConfig);

if (worker) {
  worker.postMessage(
    {
      canvas: offscreenCanvas,
      displayWidth: initialRuntimeConfig.displayWidth,
      displayHeight: initialRuntimeConfig.displayHeight,
      windowWidth: initialRuntimeConfig.windowWidth,
      windowHeight: initialRuntimeConfig.windowHeight,
    },
    [offscreenCanvas],
  );
}

window.updateDisplayRendererConfig = function updateDisplayRendererConfig(nextConfig) {
  var runtimeConfig = buildRuntimeConfig(nextConfig || {});
  window.displayWidth = runtimeConfig.displayWidth;
  window.displayHeight = runtimeConfig.displayHeight;
  applyCanvasViewport(runtimeConfig);
  if (worker) {
    worker.postMessage({
      config: runtimeConfig,
    });
  }
};

window.addEventListener("resize", function () {
  if (typeof window.updateDisplayRendererConfig === "function") {
    window.updateDisplayRendererConfig();
  }
});

if (worker) {
  worker.onmessage = function (_event) {};
}

window.addEventListener("beforeunload", function () {
  if (worker && worker.__blobUrl) {
    URL.revokeObjectURL(worker.__blobUrl);
  }
});

function drawDisplayFrame(arrayBuffer) {
  if (!worker) {
    return;
  }
  worker.postMessage({ h264Data: arrayBuffer });
}
