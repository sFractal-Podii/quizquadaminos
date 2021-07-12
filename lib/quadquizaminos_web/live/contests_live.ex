defmodule QuadquizaminosWeb.ContestsLive do
  use Phoenix.LiveView
  import Phoenix.HTML.Form
  import Phoenix.LiveView.Helpers

  alias Quadquizaminos.Repo

  alias Quadquizaminos.Contests
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

  def handle_event("pause",  %{"contest" => contest}, socket) do
    send_update(QuadquizaminosWeb.ContestComponent,
    id: contest,
    contest: contest(contest, socket.assigns.started_contests),
    running: false
  )
    {:noreply, assign(socket, payloads: update_payload(socket.assigns.payloads, contest))}

  end

  defp update_payload(%{contest_name: contest_name} = payload, contest) when contest==contest_name do
    Map.put(payload, :running, false)
  end

  defp update_payload([_h | _t]= payloads, contest) do
    Enum.map(payloads, fn payload -> update_payload(payload, contest) end)
  end

  defp update_payload(payload, _contest) do
    payload
  end

  def handle_info(%{event: "timer", payload: payload}, socket) do
    contest = Contests.get_contest(payload[:contest_name])

    {:noreply,
     socket
     |> assign(
       payloads: socket.assigns.payloads ++ [payload],
       started_contests: socket.assigns.started_contests ++ [contest]
     )}
  end

  def handle_info(:timer, %{assigns: %{payloads: [%{running: true} | _] = payloads}} = socket) do
    Enum.each(payloads, fn payload ->
      send_update(QuadquizaminosWeb.ContestComponent,
        id: payload[:contest_name],
        contest: contest(payload[:contest_name], socket.assigns.started_contests),
        running: true
      )
    end)

    {:noreply, socket}
  end

  def handle_info(:timer, socket) do
    {:noreply, socket}
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
end
