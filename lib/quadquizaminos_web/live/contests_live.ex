defmodule QuadquizaminosWeb.ContestsLive do
  use Phoenix.LiveView
  import Phoenix.HTML.Form

  alias Quadquizaminos.Repo

  alias Quadquizaminos.Contest
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  def mount(_params, session, socket) do
    {:ok, socket |> assign(all_contests: all_contests())}
  end

  def handle_event("save", %{"key" => "Enter", "value" => contest_name}, socket) do
    {:noreply, socket |> _create_contest(contest_name)}
  end

  defp _create_contest(socket, contest_name) do
    case %Contest{} |> Contest.changeset(%{name: contest_name}) |> Repo.insert() do
      {:ok, contest} -> assign(socket, all_contest: all_contests() ++ [contest])
      _ -> socket
    end
  end

  defp all_contests do
    Repo.all(Contest)
  end
end
