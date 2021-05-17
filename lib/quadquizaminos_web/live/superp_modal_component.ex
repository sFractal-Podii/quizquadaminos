defmodule QuadquizaminosWeb.SuperpModalComponent do
  use QuadquizaminosWeb, :live_component

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
    <i class="fas fa-fast-forward" </i>
    make blocks fall faster
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="slowdown">
    <i class="fas fa-fast-backward" </i>
    make blocks fall slower
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="fixvuln">
    <i class="fas fa-wrench" </i>
    fix one vulnerability
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="fixlicense">
    <i class="fas fa-screwdriver" </i>
    fix one licensing issue
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="rm_all_vulns">
    <i class="fas fa-hammer" </i>
    remove all vulnerabilities
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="rm_all_lic_issues">
    <i class="fas fa-tape" </i>
    remove all licensing issues
    </button>

    </div>
    """
  end


end
