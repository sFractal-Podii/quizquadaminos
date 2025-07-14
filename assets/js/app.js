import "../css/app.css";
import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";

let Hooks = {};
var keyDownHandler;

function disableKeys() {
  // Check if the element with id "gamearea" exists
  if (document.getElementById("gamearea")) {
    // Define the event handler function
    keyDownHandler = function (e) {
      // If the pressed key is one of the specified keys, prevent the default action
      var keysToBlock = [
        "Space",
        "ArrowUp",
        "ArrowDown",
        "ArrowLeft",
        "ArrowRight",
      ];
      if (keysToBlock.indexOf(e.code) > -1) {
        e.preventDefault();
      }
    };
    // Add the event listener
    window.addEventListener("keydown", keyDownHandler, false);
  }
}

function reenableKeys() {
  // Remove the event listener if it was set
  if (keyDownHandler) {
    window.removeEventListener("keydown", keyDownHandler, false);
    keyDownHandler = null;
  }
}

Hooks.DisableArrow = {
  mounted() {
    disableKeys();
  },
  destroyed() {
    reenableKeys();
  },
};

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
});

// connect if there are any LiveViews on the page
liveSocket.connect();

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
