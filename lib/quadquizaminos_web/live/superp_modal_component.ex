defmodule QuadquizaminosWeb.SuperpModalComponent do
  use QuadquizaminosWeb, :live_component

  def render(assigns) do
    ~L"""
    <div style="text-align:center;">
    <%= p_deleteblock() %>
    <%= p_addblock() %>
    <%= p_moveblock() %>
    <%= p_clearblocks() %>
    <%= p_speedup() %>
    <%= p_slowdown() %>
    <%= p_fixvuln() %>
    <%= p_fixlicense() %>
    <%= p_rm_all_vulns() %>
    <%= p_rm_all_lic_issues() %>
    </div>
    """
  end

  defp p_deleteblock() do
    """
    <br>
    <button phx-click="super_to_power" phx-value-spower="deleteblock">
    <i class="fa-minus-square" </i>
    remove a block
    </button>
    """
  end

  defp p_addblock() do
    """
    <br>
    <button phx-click="super_to_power" phx-value-spower="addblock">
    <i class="fa-plus-square" </i>
    add a block
    </button>
    """
  end

  defp p_moveblock() do
    """
    <br>
    <button phx-click="super_to_power" phx-value-spower="moveblock">
    <i class="fa-arrows-alt" </i>
    move a block
    </button>
    """
  end

  defp p_clearblocks() do
    """
    <br>
    <button phx-click="super_to_power" phx-value-spower="clearblocks">
    <i class="fa-eraser" </i>
    clear gameboard of all blocks
    </button>
    """
  end

  defp p_speedup() do
    """
    <br>
    <button phx-click="super_to_power" phx-value-spower="speedup">
    <i class="fa-fast-forward" </i>
    make blocks fall faster
    </button>
    """
  end

  defp p_slowdown() do
    """
    <br>
    <button phx-click="super_to_power" phx-value-spower="slowdown">
    <i class="fa-fast-backward" </i>
    make blocks fall slower
    </button>
    """
  end

  defp p_fixvuln() do
    """
    <br>
    <button phx-click="super_to_power" phx-value-spower="fixvuln">
    <i class="fa-wrench" </i>
    fix one vulnerability
    </button>
    """
  end

  defp p_fixlicense() do
    """
    <br>
    <button phx-click="super_to_power" phx-value-spower="fixlicense">
    <i class="fa-screwdriver" </i>
    fix one licensing issue
    </button>
    """
  end

  defp p_rm_all_vulns() do
    """
    <br>
    <button phx-click="super_to_power" phx-value-spower="rm_all_vulns">
    <i class="fa-hammer" </i>
    remove all vulnerabilities
    </button>
    """
  end

  defp p_rm_all_lic_issues() do
    """
    <br>
    <button phx-click="super_to_power" phx-value-spower="rm_all_lic_issues">
    <i class="fa-tape" </i>
    remove all licensing issues
    </button>
    """
  end

end
