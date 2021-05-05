defmodule QuadquizaminosWeb.ContestboardLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    :timer.send_interval(1000, self(), :count_down)
    {:ok, socket |> assign(start_date: DateTime.utc_now())}
  end

  def render(assigns) do
    ~L"""
    <h1>Contest coming soon </h1>
    """
  end

  def handle_info(:count_down, socket) do
    IO.inspect(socket.assigns.start_date)
    {:noreply, socket}
  end

  defp date_count() do
  end
end
