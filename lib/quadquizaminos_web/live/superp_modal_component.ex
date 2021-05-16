defmodule QuadquizaminosWeb.SuperpModalComponent do
  use QuadquizaminosWeb, :live_component

  def render(assigns) do
    ~L"""
    <div style="text-align:center;">
    <br>
    <button phx-click="super_to_power" phx-value-spower="deleteblock">
    <i class="fa-minus-square" </i>
    remove a block
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="addblock">
    <i class="fa-plus-square" </i>
    add a block
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="moveblock">
    <i class="fa-arrows-alt" </i>
    move a block
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="clearblocks">
    <i class="fa-eraser" </i>
    clear gameboard of all blocks
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="speedup">
    <i class="fa-fast-forward" </i>
    make blocks fall faster
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="slowdown">
    <i class="fa-fast-backward" </i>
    make blocks fall slower
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="fixvuln">
    <i class="fa-wrench" </i>
    fix one vulnerability
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="fixlicense">
    <i class="fa-screwdriver" </i>
    fix one licensing issue
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="rm_all_vulns">
    <i class="fa-hammer" </i>
    remove all vulnerabilities
    </button>

    <br>
    <button phx-click="super_to_power" phx-value-spower="rm_all_lic_issues">
    <i class="fa-tape" </i>
    remove all licensing issues
    </button>

    </div>
    """
  end


end
