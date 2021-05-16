defmodule QuadquizaminosWeb.SuperpModalComponent do
  use QuadquizaminosWeb, :live_component
  alias Quadquizaminos.QnA

  def render(assigns) do
    ~L"""
    <div style="text-align:center;">

    power = :deleteblock
    icon  = "fa-minus-square"
    descr = "remove a block"
    <%= powers_button(power, icon, descr) %>

    power = :addblock
    icon  = "fa-plus-square"
    descr = "add a block"
    <%= powers_button(power, icon, descr) %>

    :moveblock -> "fa-arrows-alt"
    power = :x
    icon  = "fa-x"
    descr = "x"
    <%= powers_button(power, icon, descr) %>

    power = :x
    icon  = "fa-x"
    descr = "x"
    <%= powers_button(power, icon, descr) %>

    :clearblocks -> "fa-eraser"
    power = :x
    icon  = "fa-x"
    descr = "x"
    <%= powers_button(power, icon, descr) %>

    :speedup -> "fa-fast-forward"
    power = :x
    icon  = "fa-x"
    descr = "x"
    <%= powers_button(power, icon, descr) %>

    :slowdown -> "fa-fast-backward"
    power = :x
    icon  = "fa-x"
    descr = "x"
    <%= powers_button(power, icon, descr) %>

    :fixvuln -> "fa-wrench"
    power = :x
    icon  = "fa-x"
    descr = "x"
    <%= powers_button(power, icon, descr) %>

    :fixlicense -> "fa-screwdriver"
    power = :x
    icon  = "fa-x"
    descr = "x"
    <%= powers_button(power, icon, descr) %>

    :rm_all_vulns -> "fa-hammer"
    power = :x
    icon  = "fa-x"
    descr = "x"
    <%= powers_button(power, icon, descr) %>

    :rm_all_lic_issues -> "fa-tape"
    power = :x
    icon  = "fa-x"
    descr = "x"
    <%= powers_button(power, icon, descr) %>

    </div>
    """
  end

  defp powers_button(power, icon, descr) do
    ~L"""
    <br>
    <button phx-click="super_to_power" phx-value-power="<%= power |> to_string() %>">
    <i class="fas <%=icon %>" </i>
    <%=descr %>
    </button>
    """
  end


end
