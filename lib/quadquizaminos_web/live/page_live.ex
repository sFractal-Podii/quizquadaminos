defmodule QuadquizaminosWeb.PageLive do
  use QuadquizaminosWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    current_user = Map.get(session, :current_user)
    IO.inspect(current_user, label: "==================================")
    {:ok, assign(socket, current_user: current_user)}
  end
end
