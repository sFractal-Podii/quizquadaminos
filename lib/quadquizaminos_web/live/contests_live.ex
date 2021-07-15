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

    {:ok,
     socket |> assign(payloads: [], started_contests: [], contests: Contests.list_contests())}
  end

  def handle_event("save", %{"key" => "Enter", "value" => contest_name}, socket) do
    {:noreply, socket |> _create_contest(contest_name)}
  end

  def handle_event("start", %{"contest" => name}, socket) do
    {:noreply, _update_contest(socket, name)}
  end

  def handle_event("pause", %{"contest" => name}, socket) do
    Contests.pause_contest(name)
    {:noreply, socket}
  end

  def handle_info(%{event: "started", payload: payload}, socket) do
    contest = Contests.get_contest(payload[:contest_name])

    {:noreply,
     socket
     |> assign(
       payloads: socket.assigns.payloads ++ [payload],
       started_contests: socket.assigns.started_contests ++ [contest]
     )}
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

    # IO.inspect(contests: contests ++ inactive_contest, label: "+++++++++++++++++++++++++")

    {:noreply, assign(socket, contests: contests ++ inactive_contest)}
  end

  defp contest(name, started_contests) do
    Enum.find(started_contests, fn contest -> contest.name == name end)
  end

  defp _create_contest(socket, contest_name) do
    contests = socket.assigns.contests

    case Contests.create_contest(%{name: contest_name}) do
      {:ok, contest} -> assign(socket, contests: contests ++ [contest])
      _ -> socket
    end
  end

  defp _update_contest(socket, name) do
    contest = Contests.get_contest(name)
    contests = socket.assigns.contests -- [contest]

    case Contests.start_contest(name) do
      {:ok, {:ok, contest}} ->
        socket
        |> assign(contests: contest)
        |> assign(contests: contests ++ [contest])

      _ ->
        socket
    end
  end

  defp update_payload(%{contest_name: contest_name} = payload, contest)
       when contest == contest_name do
    Map.put(payload, :running, false)
  end

  defp update_payload([_h | _t] = payloads, contest) do
    Enum.map(payloads, fn payload -> update_payload(payload, contest) end)
  end

  defp update_payload(payload, _contest) do
    payload
  end

  defp is_contest_paused?(payloads, started_contests, contest_name) do
    payloads
    |> Enum.find(fn payload -> payload.contest_name == contest_name end)
    |> is_contest_paused?(started_contests)
  end

  defp is_contest_paused?(%{contest_name: contest_name, running: false}, started_contests) do
    Enum.any?(started_contests, fn contest ->
      contest.name == contest_name && is_nil(contest.end_time)
    end)
  end

  defp is_contest_paused?(nil, _started_contests), do: false

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
