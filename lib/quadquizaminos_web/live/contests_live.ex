defmodule QuadquizaminosWeb.ContestsLive do
  @moduledoc """
  
  This is a module that does the following:
  - Finds the already started contests
  - Add the created contest to the socket
  - Add the created contest to the contest list
  - Ensures that the ended contest does not appear twice in the contest list
  - Calculates the counter timer

  """
  use Phoenix.LiveView
  import Phoenix.HTML.Form
  import Phoenix.LiveView.Helpers

  alias Quadquizaminos.Repo

  alias Quadquizaminos.{Contests, Contest}
  alias Quadquizaminos.Util
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  def mount(_params, session, socket) do
    :timer.send_interval(1000, self(), :timer)
    QuadquizaminosWeb.Endpoint.subscribe("timer")

    {:ok,
     socket |> assign(payloads: [], started_contests: [], contests: Contests.list_contests())}
  end

  def handle_event("save", %{"key" => "Enter", "value" => contest_name}, socket) do
    {:noreply, socket |> _create_contest(contest_name)}
  end

  def handle_event("start", %{"contest" => name}, socket) do
    socket =
      if name in Contests.active_contests_names() do
        Contests.resume_contest(name)
        socket
      else
        _start_contest(socket, name)
      end

    {:noreply, socket}
  end

  def handle_event("pause", %{"contest" => name}, socket) do
    Contests.pause_contest(name)
    {:noreply, socket}
  end

  def handle_event("reset", %{"contest" => name}, socket) do
    Contests.reset_contest(name)
    {:noreply, socket}
  end

  def handle_event("stop", %{"contest" => name}, socket) do
    {:noreply, _end_contest(socket, name)}
  end

  def handle_info(:timer, socket) do
    inactive_contest =
      Enum.reject(socket.assigns.contests, fn contest ->
        contest.name in Contests.active_contests_names()
      end)

    contests =
      Contests.active_contests_names()
      |> Enum.map(fn name ->
        time = Contests.time_elapsed(name)
        status = Contests.contest_status(name)

        contest =
          Enum.find(socket.assigns.contests, fn contest ->
            contest.name == name
          end)

        %{contest | time_elapsed: time, status: to_string(status)}
      end)

    {:noreply, assign(socket, contests: contests ++ inactive_contest)}
  end

  defp _create_contest(socket, contest_name) do
    contests = socket.assigns.contests

    case Contests.create_contest(%{name: contest_name}) do
      {:ok, contest} -> assign(socket, contests: contests ++ [contest])
      _ -> socket
    end
  end

  defp _start_contest(socket, name) do
    contests = Enum.reject(socket.assigns.contests, fn contest -> contest.name == name end)

    case Contests.start_contest(name) do
      {:ok, {:ok, contest}} ->
        socket
        |> assign(contests: contests ++ [contest])

      _ ->
        socket
    end
  end

  defp _end_contest(socket, name) do
    contests = Enum.reject(socket.assigns.contests, fn contest -> contest.name == name end)

    case Contests.end_contest(name) do
      {:ok, {:ok, contest}} ->
        socket
        |> assign(contests: contests ++ [contest])

      _ ->
        socket
    end
  end

  defp start_or_pause_button(assigns, contest) do
    if contest.status == "running" do
      ~L"""
      <button phx-click="pause" phx-value-contest='<%= contest.name %>'>Pause</button>
      """
    else
      ~L"""
      <button phx-click="start" phx-value-contest='<%= contest.name %>'>Start</button>
      """
    end
  end

  defp to_human_time(seconds) do
    hours = div(seconds, 3600)
    rem = rem(seconds, 3600)
    minutes = div(rem, 60)
    rem = rem(rem, 60)
    seconds = div(rem, 1)
    {hours, minutes, seconds}
  end
end
