defmodule QuadquizaminosWeb.ContestsLive do
  use Phoenix.LiveView
  import Phoenix.HTML.Form

  def mount(_params, session, socket) do
    {:ok, socket}
  end

  def handle_event("haha", %{"key" => "Enter", "value" => value}, socket) do
    {:noreply, socket}
  end
end
