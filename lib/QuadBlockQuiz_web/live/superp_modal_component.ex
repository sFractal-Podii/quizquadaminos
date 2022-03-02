defmodule QuadblockquizWeb.SuperpModalComponent do
  use QuadblockquizWeb, :live_component

  def render(assigns) do
    ~L"""
    <div style="text-align:center;">
    <br>
    <button phx-click="super_to_power" phx-value-spower="deleteblock">
    remove a block
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="addblock">
    add a block
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="moveblock">
    move a block
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="clearblocks">
    clear gameboard of all blocks
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="speedup">
    make blocks fall faster
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="slowdown">
    make blocks fall slower
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="fixvuln">
    fix one vulnerability
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="fixlicense">
    fix one licensing issue
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="rm_all_vulns">
    remove all vulnerabilities
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="rm_all_lic_issues">
    remove all licensing issues
    </button>

    </div>
    """
  end
end
