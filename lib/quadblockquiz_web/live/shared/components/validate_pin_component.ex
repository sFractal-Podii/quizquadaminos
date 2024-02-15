defmodule QuadblockquizWeb.SharedLive.ValidatePinComponent do
  use QuadblockquizWeb, :live_component

  def update(assigns, socket) do
    {:ok,
     socket |> assign(redirect_to: assigns.redirect_to, pin: assigns.pin, form: to_form(%{}))}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h3>Enter PIN</h3>
      <.form for={@form} phx-submit={:validate} phx-target={@myself}>
        <label>Pin</label>
        <.input field={f[:pin]} />
        <button>Start</button>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"contest" => %{"pin" => pin} = params}, socket) do
    redirect_path = URI.parse(socket.assigns.redirect_to).path

    if pin == socket.assigns.pin do
      send(self(), {:update_pin_status, request_pin?: false})

      {:noreply,
       socket
       |> assign(form: to_form(params))
       |> push_patch(to: redirect_path)}
    else
      {:noreply, socket}
    end
  end
end
