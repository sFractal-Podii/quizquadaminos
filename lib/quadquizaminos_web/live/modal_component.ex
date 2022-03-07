defmodule QuadquizaminosWeb.ModalComponent do
  use QuadquizaminosWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div id="<%= @id %>" class="phx-modal"
      phx-target="#<%= @id %>"
      phx-page-loading>

      <div class="phx-modal-content">
        <%= live_component @socket, @component, @opts %>
      </div>
    </div>
    """
  end
end
