defmodule QuadquizaminosWeb.ContestsLive do
  use Phoenix.LiveView

  import Phoenix.LiveView.Helpers
  import Phoenix.HTML, only: [raw: 1]
  import Phoenix.HTML.{Form, Tag}
  alias QuadquizaminosWeb.AdminContestsLive
  alias Quadquizaminos.Contests
  alias QuadquizaminosWeb.ContestsLive.ContestComponent
  alias Quadquizaminos.Accounts
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.Util

  def mount(_params, session, socket) do
    :timer.send_interval(1000, self(), :update_component_timer)
    QuadquizaminosWeb.Endpoint.subscribe("contest_scores")
    current_user = session["uid"] |> current_user()

    {:ok,
     socket
     |> assign(
       current_user: current_user,
       contests: Contests.list_contests(),
       contest_records: [],
       contest_id: nil
     )}
  end

  def handle_info(:update_component_timer, socket) do
    Enum.map(socket.assigns.contests, fn contest ->
      send(self(), {:update_component, contest_id: contest.id})
    end)

    {:noreply, socket}
  end

  def handle_info({:update_component, contest_id: contest_id}, socket) do
    send_update(ContestComponent, id: contest_id, current_user: socket.assigns.current_user)
    {:noreply, socket}
  end

  def handle_info(:timer, socket) do
    {:noreply, AdminContestLive._update_contests_timer(socket)}
  end

  def handle_info(%{event: "current_scores", payload: payload}, socket) do
    contest_records = socket.assigns.contest_records

    contest_records =
      (contest_records ++ payload)
      |> Enum.sort_by(& &1.score, :desc)
      |> Enum.uniq_by(& &1.uid)
      |> Enum.take(10)

    contest_records =
      case socket.assigns.contest_id do
        nil -> contest_records
        contest_id -> contest_live_records(contest_records, contest_id)
      end

    {:noreply, socket |> assign(contest_records: contest_records)}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    {:noreply, assign(socket, id: id, contest_records: contest_records(id))}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp contest_live_records(records, contest_id) do
    Enum.filter(records, fn record -> record.contest_id == contest_id end)
  end

  defp contest_records(contest_id) do
    case String.to_integer(contest_id) |> Contests.get_contest() do
      nil ->
        []

      contest ->
        Contests.contest_game_records(contest)
    end
  end

  defp timer_or_final_result(assigns, contest) do
    if contest.end_time do
      ~L"""
      <%= live_redirect "Final Results", class: "button",  to: Routes.contests_path(@socket, :show, contest)%>

      """
    else
      ~L"""

      <% {hours, minutes, seconds} = contest.time_elapsed |> to_human_time() %>
      <p><%= Util.count_display(hours) %>:<%= Util.count_display(minutes) %>:<%= Util.count_display(seconds) %></p>

      """
    end
  end

  defp live_result_button(assigns, contest) do
    if contest.name in Contests.active_contests_names() do
      ~L"""
      <%= live_redirect "Live Results", class: "button",  to: Routes.contests_path(@socket, :show, contest)%>

      """
    else
      ""
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

  defp group_contest_by_status(contests) do
    contests
    |> Enum.map(fn contest ->
      %{contest | status: Contests.contest_status(contest.name)}
    end)
    |> Enum.group_by(fn contest -> contest.status end)
    |> Enum.sort({:asc, Contests.Contest})
  end

  defp status(:stopped), do: "Past"

  defp status(status) do
    status |> to_string() |> Macro.camelize()
  end

  defp current_user(nil) do
    %User{uid: nil, admin?: false}
  end

  defp current_user(uid) do
    case Accounts.get_user(uid) do
      nil -> %User{uid: "anonymous", name: "anonymous"}
      %User{} = user -> %{user | admin?: admin?(uid)}
    end
  end

  defp admin?(current_user) do
    ids = Application.get_env(:quadquizaminos, :github_ids)

    current_user in (ids |> Enum.map(&(&1 |> to_string())))
  end
end
