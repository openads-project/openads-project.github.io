/* Zoom/pan behaviour for inlined SVG diagrams (see _ext/svg_viewer.py).
 *
 * The SVG lives in the page DOM, so anchors inside it behave like ordinary
 * links. Everything here therefore has to leave clicks on <a> elements alone
 * and only act on interactions with the diagram background.
 */
(function () {
  "use strict";

  var MIN_SCALE = 1;
  var MAX_SCALE = 16;
  var STEP = 1.4;
  var DRAG_THRESHOLD = 4; // px of movement before a click counts as a drag
  var PAN_KEY_STEP = 60;

  function clamp(value, min, max) {
    return Math.min(Math.max(value, min), max);
  }

  function Viewer(figure) {
    this.figure = figure;
    this.stage = figure.querySelector(".svg-viewer__stage");
    this.canvas = figure.querySelector(".svg-viewer__canvas");
    this.expandBtn = figure.querySelector('[data-action="expand"]');
    this.zoomOutBtn = figure.querySelector('[data-action="zoom-out"]');

    this.scale = 1;
    this.tx = 0;
    this.ty = 0;
    this.expanded = false;
    this.dragged = false;

    this.bindControls();
    this.bindPointer();
    this.bindKeyboard();
    this.render();
  }

  /* --- Transform ------------------------------------------------------- */

  Viewer.prototype.render = function () {
    var stageW = this.stage.clientWidth;
    var stageH = this.stage.clientHeight;
    var contentW = this.canvas.offsetWidth * this.scale;
    var contentH = this.canvas.offsetHeight * this.scale;

    // Centre the diagram while it is smaller than the stage, otherwise keep
    // its edges from being dragged into the middle of the viewport.
    this.tx =
      contentW <= stageW
        ? (stageW - contentW) / 2
        : clamp(this.tx, stageW - contentW, 0);
    this.ty =
      contentH <= stageH
        ? (stageH - contentH) / 2
        : clamp(this.ty, stageH - contentH, 0);

    this.canvas.style.transform =
      "translate(" + this.tx + "px, " + this.ty + "px) scale(" + this.scale + ")";
    this.zoomOutBtn.disabled = this.scale <= MIN_SCALE;
  };

  Viewer.prototype.zoomAt = function (clientX, clientY, factor) {
    var next = clamp(this.scale * factor, MIN_SCALE, MAX_SCALE);
    if (next === this.scale) return;

    // Keep the point under the cursor/fingers fixed while the scale changes.
    var rect = this.stage.getBoundingClientRect();
    var px = clientX - rect.left;
    var py = clientY - rect.top;
    var ratio = next / this.scale;

    this.tx = px - (px - this.tx) * ratio;
    this.ty = py - (py - this.ty) * ratio;
    this.scale = next;
    this.render();
  };

  Viewer.prototype.zoomCentre = function (factor) {
    var rect = this.stage.getBoundingClientRect();
    this.zoomAt(rect.left + rect.width / 2, rect.top + rect.height / 2, factor);
  };

  Viewer.prototype.reset = function () {
    this.scale = 1;
    this.tx = 0;
    this.ty = 0;
    this.render();
  };

  /* --- Expanded overlay ------------------------------------------------ */

  Viewer.prototype.expand = function () {
    if (this.expanded) return;
    // Reserve the stage's height so the page does not jump when it goes fixed.
    this.figure.style.minHeight = this.stage.offsetHeight + "px";
    this.figure.classList.add("is-expanded");
    document.body.classList.add("svg-viewer-open");
    this.expanded = true;
    this.expandBtn.innerHTML = "&#10006;";
    this.expandBtn.title = "Close";
    this.expandBtn.setAttribute("aria-label", "Close enlarged diagram");
    this.reset();
    this.stage.focus();
  };

  Viewer.prototype.collapse = function () {
    if (!this.expanded) return;
    this.figure.classList.remove("is-expanded");
    this.figure.style.minHeight = "";
    document.body.classList.remove("svg-viewer-open");
    this.expanded = false;
    this.expandBtn.innerHTML = "&#10530;";
    this.expandBtn.title = "Enlarge";
    this.expandBtn.setAttribute("aria-label", "Enlarge diagram");
    this.reset();
  };

  /* --- Controls and clicks --------------------------------------------- */

  Viewer.prototype.bindControls = function () {
    var self = this;

    this.figure.querySelectorAll(".svg-viewer__btn").forEach(function (btn) {
      btn.addEventListener("click", function (event) {
        event.stopPropagation();
        var action = btn.getAttribute("data-action");
        if (action === "zoom-in") self.zoomCentre(STEP);
        else if (action === "zoom-out") self.zoomCentre(1 / STEP);
        else if (action === "reset") self.reset();
        else if (self.expanded) self.collapse();
        else self.expand();
      });
    });

    this.stage.addEventListener("click", function (event) {
      if (self.dragged) {
        // Swallow the click that ends a pan gesture.
        event.preventDefault();
        event.stopPropagation();
        return;
      }
      // Links and controls keep their normal behaviour.
      if (event.target.closest("a, .svg-viewer__btn")) return;
      if (!self.expanded) self.expand();
    });

    this.stage.addEventListener("dblclick", function (event) {
      if (event.target.closest("a")) return;
      event.preventDefault();
      self.zoomAt(event.clientX, event.clientY, STEP);
    });

    this.stage.addEventListener(
      "wheel",
      function (event) {
        // Outside the overlay, plain scrolling must still scroll the page.
        if (!self.expanded && !event.ctrlKey && !event.metaKey) return;
        event.preventDefault();
        self.zoomAt(event.clientX, event.clientY, event.deltaY < 0 ? STEP : 1 / STEP);
      },
      { passive: false }
    );

    window.addEventListener("resize", function () {
      self.render();
    });
  };

  /* --- Pointer gestures ------------------------------------------------- */

  Viewer.prototype.bindPointer = function () {
    var self = this;
    var pointers = new Map();
    var drag = null; // one pointer: pan
    var pinch = null; // two pointers: zoom

    function positions() {
      return Array.from(pointers.values());
    }

    function spread() {
      var p = positions();
      return Math.hypot(p[0].x - p[1].x, p[0].y - p[1].y);
    }

    function midpoint() {
      var p = positions();
      return { x: (p[0].x + p[1].x) / 2, y: (p[0].y + p[1].y) / 2 };
    }

    this.stage.addEventListener("pointerdown", function (event) {
      if (event.target.closest(".svg-viewer__btn")) return;
      pointers.set(event.pointerId, { x: event.clientX, y: event.clientY });

      if (pointers.size === 2) {
        drag = null; // a second finger turns the gesture into a pinch
        pinch = { spread: spread(), scale: self.scale };
      } else if (pointers.size === 1 && event.button === 0) {
        drag = { x: event.clientX, y: event.clientY, tx: self.tx, ty: self.ty };
        self.dragged = false;
      }
    });

    // Listen on the window so a gesture survives leaving the stage.
    window.addEventListener("pointermove", function (event) {
      if (!pointers.has(event.pointerId)) return;
      pointers.set(event.pointerId, { x: event.clientX, y: event.clientY });

      if (pinch && pointers.size === 2) {
        self.dragged = true;
        var mid = midpoint();
        self.zoomAt(mid.x, mid.y, (spread() / pinch.spread) * (pinch.scale / self.scale));
        return;
      }

      if (!drag) return;
      var dx = event.clientX - drag.x;
      var dy = event.clientY - drag.y;

      if (!self.dragged) {
        if (Math.abs(dx) < DRAG_THRESHOLD && Math.abs(dy) < DRAG_THRESHOLD) return;
        self.dragged = true;
        self.stage.classList.add("is-panning");
      }
      self.tx = drag.tx + dx;
      self.ty = drag.ty + dy;
      self.render();
    });

    ["pointerup", "pointercancel"].forEach(function (type) {
      window.addEventListener(type, function (event) {
        if (!pointers.delete(event.pointerId)) return;
        if (pointers.size < 2) pinch = null;
        if (pointers.size > 0) return;

        drag = null;
        self.stage.classList.remove("is-panning");
        // Cleared only after the click event that follows this pointerup.
        window.setTimeout(function () {
          self.dragged = false;
        }, 0);
      });
    });

    // Suppress the browser's native drag ghost for SVG shapes and links.
    this.stage.addEventListener("dragstart", function (event) {
      event.preventDefault();
    });
  };

  /* --- Keyboard --------------------------------------------------------- */

  Viewer.prototype.bindKeyboard = function () {
    var self = this;

    this.stage.addEventListener("keydown", function (event) {
      if (event.target.closest("a, .svg-viewer__btn")) return;
      var handled = true;

      switch (event.key) {
        case "+":
        case "=":
          self.zoomCentre(STEP);
          break;
        case "-":
          self.zoomCentre(1 / STEP);
          break;
        case "0":
          self.reset();
          break;
        case "Enter":
        case " ":
          self.expanded ? self.collapse() : self.expand();
          break;
        case "ArrowLeft":
          self.tx += PAN_KEY_STEP;
          self.render();
          break;
        case "ArrowRight":
          self.tx -= PAN_KEY_STEP;
          self.render();
          break;
        case "ArrowUp":
          self.ty += PAN_KEY_STEP;
          self.render();
          break;
        case "ArrowDown":
          self.ty -= PAN_KEY_STEP;
          self.render();
          break;
        default:
          handled = false;
      }
      if (handled) event.preventDefault();
    });
  };

  /* --- Bootstrap -------------------------------------------------------- */

  function init() {
    var viewers = [];
    document.querySelectorAll("[data-svg-viewer]").forEach(function (figure) {
      viewers.push(new Viewer(figure));
    });

    document.addEventListener("keydown", function (event) {
      if (event.key !== "Escape") return;
      viewers.forEach(function (viewer) {
        viewer.collapse();
      });
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
