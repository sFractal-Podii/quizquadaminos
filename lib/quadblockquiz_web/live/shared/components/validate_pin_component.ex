defmodule QuadblockquizWeb.SharedLive.ValidatePinComponent do
  use QuadblockquizWeb, :live_component

  def update(assigns, socket) do
    {:ok, socket |> assign(redirect_to: assigns.redirect_to, pin: assigns.pin)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h3>Enter PIN</h3>
      <.form :let={f} for={:contest} phx-submit={:validate} phx-target={@myself}>
        {label(f, :pin)}
        {text_input(f, :pin, type: :text)}
        {error_tag(f, :pin)}
        <button>Start</button>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"contest" => %{"pin" => pin}}, socket) do
    redirect_path = URI.parse(socket.assigns.redirect_to).path

    if pin == socket.assigns.pin do
      send(self(), {:update_pin_status, request_pin?: false})

      {:noreply,
       socket
       |> push_patch(to: redirect_path)}
    else
      {:noreply, socket}
    end
  end
end
