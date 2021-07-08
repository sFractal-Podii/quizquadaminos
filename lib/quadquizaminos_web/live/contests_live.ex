defmodule QuadquizaminosWeb.ContestsLive do
  use Phoenix.LiveView
  import Phoenix.HTML.Form

  alias Quadquizaminos.Repo

  alias Quadquizaminos.Contest
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  def mount(_params, session, socket) do
    {:ok, socket |> assign(contests: contests())}
  end

  def handle_event("save", %{"key" => "Enter", "value" => contest_name}, socket) do
    {:noreply, socket |> _create_contest(contest_name)}
  end

  defp _create_contest(socket, contest_name) do
    contests = socket.assigns.contests

    case %Contest{} |> Contest.changeset(%{name: contest_name}) |> Repo.insert() do
      {:ok, contest} -> assign(socket, contests: contests ++ [contest])
      _ -> socket
    end
    |> IO.inspect(label: "===============================")
  end

  defp contests do
    Repo.all(Contest)
  end
end
