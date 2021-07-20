defmodule QuadquizaminosWeb.ContestsLive do
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

    {:ok, socket |> assign(contests: Contests.list_contests())}
  end

  def handle_event("save", %{"key" => "Enter", "value" => contest_name}, socket) do
    {:noreply, socket |> _create_contest(contest_name)}
  end

  def handle_event("start", %{"contest" => name}, socket) do
    {:noreply, start_or_resume_contest(socket, name)}
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
    {:noreply, _update_contests_timer(socket)}
  end

  defp _update_contests_timer(socket) do
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

    assign(socket, contests: contests ++ inactive_contest)
  end

  defp _create_contest(socket, contest_name) do
    contests = socket.assigns.contests

    case Contests.create_contest(%{name: contest_name}) do
      {:ok, contest} -> assign(socket, contests: contests ++ [contest])
      _ -> socket
    end
  end

  defp _start_contest(socket, name) do
    contests =
      Enum.map(socket.assigns.contests, fn
        contest ->
          if contest.name == name do
            {:ok, {:ok, started_contest}} = Contests.start_contest(name)
            started_contest
          else
            contest
          end
      end)

    assign(socket, contests: contests)
  end

  defp _end_contest(socket, name) do
    contests =
      Enum.map(socket.assigns.contests, fn
        contest ->
          if contest.name == name do
            {:ok, {:ok, ended_contest}} = Contests.end_contest(name)
            ended_contest
          else
            contest
          end
      end)

    assign(socket, contests: contests)
  end

  defp start_or_pause_button(assigns, contest) do
    if contest.status == "running" do
      ~L"""
      <button class= "<%= if contest.end_time, do: 'not_allowed' %>" phx-click="pause" phx-value-contest='<%= contest.name  %>' <%= if contest.end_time, do: 'disabled' %> >Pause</button>
      """
    else
      ~L"""
      <button class= "<%= if contest.end_time, do: 'not_allowed' %>" phx-click="start" phx-value-contest='<%= contest.name %>' <%= if contest.end_time, do: 'disabled' %> >Start</button>
      """
    end
  end

  defp timer_or_final_result(assigns, contest) do
    if contest.end_time do
      ~L"""
       <button phx-click="final-score">Final Results</button>
      """
    else
      ~L"""

      <% {hours, minutes, seconds} = contest.time_elapsed |> to_human_time() %>
      <p><%= Util.count_display(hours) %>:<%= Util.count_display(minutes) %>:<%= Util.count_display(seconds) %></p>

      """
    end
  end

  defp start_or_resume_contest(socket, name) do
    if name in Contests.active_contests_names() && GenServer.whereis(name |> String.to_atom()) do
      Contests.resume_contest(name)
      socket
    else
      _start_contest(socket, name)
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

  def truncate_date(nil) do
    nil
  end

  def truncate_date(date) do
    DateTime.truncate(date, :second)
  end
end
