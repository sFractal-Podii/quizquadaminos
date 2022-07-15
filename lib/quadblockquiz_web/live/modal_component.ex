defmodule QuadblockquizWeb.ModalComponent do
  use QuadblockquizWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div id={@id} class="phx-modal" phx-target={"##{@id}"} phx-page-loading>
      <div class="phx-modal-content">
        <%= live_component(@component, @opts) %>
      </div>
    </div>
    """
  end
end
