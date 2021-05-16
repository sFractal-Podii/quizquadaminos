defmodule QuadquizaminosWeb.SuperpModalComponent do
  use QuadquizaminosWeb, :live_component
  alias Quadquizaminos.QnA

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

  defp powers_button(power, icon, descr) do
    """
    <br>
    <button phx-click="super_to_power" phx-value-power="<%= power |> to_string() %>">
    <i class="fas <%=icon %>" </i>
    <%=descr %>
    </button>
    """
  end

  defp p_deleteblock() do
    power = :deleteblock
    icon  = "fa-minus-square"
    descr = "remove a block"
    powers_button(power, icon, descr)
  end

  defp p_addblock() do
    power = :addblock
    icon  = "fa-plus-square"
    descr = "add a block"
    powers_button(power, icon, descr)
  end

  defp p_moveblock() do
    power = :moveblock
    icon  = "fa-arrows-alt"
    descr = "move a block"
    powers_button(power, icon, descr)
  end

  defp p_clearblocks() do
    power = :clearblocks
    icon  = "fa-eraser"
    descr = "clear gameboard of all blocks"
    powers_button(power, icon, descr)
  end

  defp p_speedup() do
    power = :speedup
    icon  = "fa-fast-forward"
    descr = "make blocks fall faster"
    powers_button(power, icon, descr)
  end

  defp p_slowdown() do
    power = :slowdown
    icon  = "fa-fast-backward"
    descr = "make blocks fall slower"
    powers_button(power, icon, descr)
  end

  defp p_fixvuln() do
    power = :fixvuln
    icon  = "fa-wrench"
    descr = "fix one vulnerability"
    powers_button(power, icon, descr)
  end

  defp p_fixlicense() do
    power = :fixlicense
    icon  = "fa-screwdriver"
    descr = "fix one licensing issue"
    powers_button(power, icon, descr)
  end

  defp p_rm_all_vulns() do
    power = :rm_all_vulns
    icon  = "fa-hammer"
    descr = "remove all vulnerabilities"
    powers_button(power, icon, descr)
  end

  defp p_rm_all_lic_issues() do
    power = :rm_all_lic_issues
    icon  = "fa-tape"
    descr = "remove all licensing issues"
    powers_button(power, icon, descr)
  end

end
