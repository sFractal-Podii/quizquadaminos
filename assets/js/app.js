import "../css/app.css";
import "../node_modules/@fortawesome/fontawesome-free/js/all.js";
import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";

let Hooks = {};

Hooks.DisableArrow = {
  mounted() {
    window.addEventListener(
      "keydown",
      function (evt) {
        if (evt.code == "ArrowDown") {
          evt.preventDefault();
        }
      },
      false
    );
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
