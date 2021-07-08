defmodule QuadquizaminosWeb.ContestsLive do
  use Phoenix.LiveView
  import Phoenix.HTML.Form

  alias Quadquizaminos.Repo

  alias Quadquizaminos.Contests
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  def mount(_params, session, socket) do
    {:ok, socket |> assign(contests: Contests.list_contests())}
  end

  def handle_event("save", %{"key" => "Enter", "value" => contest_name}, socket) do
    {:noreply, socket |> _create_contest(contest_name)}
  end

  defp _create_contest(socket, contest_name) do
    contests = socket.assigns.contests

    case Contests.create_contest(%{name: contest_name}) do
      {:ok, contest} -> assign(socket, contests: contests ++ [contest])
      _ -> socket
    end
  end
end
