defmodule QuadquizaminosWeb.ContestsLive do
  use Phoenix.LiveView
  import Phoenix.LiveView.Helpers
  import Phoenix.HTML, only: [raw: 1]
  alias Quadquizaminos.Contests
  alias Quadquizaminos.Util
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  @conference_date Application.fetch_env!(:quadquizaminos, :conference_date)

  def mount(_params, session, socket) do
    :timer.send_interval(1000, self(), :count_down)
    countdown_interval = DateTime.diff(@conference_date, DateTime.utc_now())
    QuadquizaminosWeb.Endpoint.subscribe("contest_scores")

    {:ok,
     socket
     |> assign(
       current_user: Map.get(session, "uid"),
       contests: Contests.list_contests(),
       countdown_interval: countdown_interval,
       contest_records: [],
       contest_id: nil
     )}
  end

  def handle_info(:count_down, socket) do
    countdown_interval = DateTime.diff(@conference_date, DateTime.utc_now())
    {:noreply, socket |> assign(countdown_interval: countdown_interval)}
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

  def countdown_timer(assigns) do
    ~L"""
    <div class="container">
            <section class="phx-hero">
                <h1>Contest countdown </h1>
                <div class="row">
                    <div class="column column-25">
                        <% {days, hours, minutes, seconds} = Util.to_human_time(@countdown_interval) %>

                        <h2><%= days |> Util.count_display() %></h2>
                        <h2>DAYS</h2>
                    </div>
                    <div class="column column-25">
                        <h2><%= Util.count_display(hours)%></h2>
                        <h2>HOURS</h2>
                    </div>
                    <div class="column column-25">
                        <h2><%=Util.count_display(minutes)%></h2>
                        <h2>MINUTES</h2>
                    </div>
                    <div class="column column-25">
                        <h2><%=Util.count_display(seconds)%></h2>
                        <h2>SECONDS</h2>
                    </div>
                </div>
                <h3>Contest coming soon</h3>
            </section>
        </div>
    """
  end
end
