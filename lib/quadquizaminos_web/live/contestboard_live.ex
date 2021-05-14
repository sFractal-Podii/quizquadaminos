defmodule QuadquizaminosWeb.ContestboardLive do
  use Phoenix.LiveView

  import Phoenix.HTML, only: [raw: 1]

  alias Quadquizaminos.Util
  alias Quadquizaminos.GameBoard.Records
  alias Phoenix.PubSub

  @initial_hour 23
  @initial_minute 59
  @initial_second 59
  def mount(_params, session, socket) do
    :timer.send_interval(1000, self(), :count_down)
    :timer.send_interval(1000, self(), :timer)
    start_date = DateTime.utc_now()
    time = current_time(start_date)
    current_user = Map.get(session, "user_id")

    {:ok,
     socket
     |> assign(
       hours: current_hour(time),
       minutes: current_minute(time),
       seconds: current_second(time),
       start_date: start_date,
       contest_minutes: 0,
       contest_second: 0,
       contest_hour: 0,
       start_timer: false,
       stop_timer: false,
       start_time: nil,
       end_time: nil,
       contest_record: [],
       seconds: 29_000,
       current_user: current_user
     )}
  end

  def render(assigns) do
    ~L"""
    <%= if Util.date_count(@start_date) < 1 do %>

    <h1>Contest Day</h1>
    <div class="row">
     <%#= if @current_user in Application.get_env(:quadquizaminos, :github_ids) do %>
      <div class="column column-25 column-offset-5">
        <section class="phx-hero">
        <h2>Timer</h2>
        <% {hours, minutes, seconds} = to_human_time(@seconds) %>
    <div class = "row">
      <div class="column column-25">
      <h2><%= Util.count_display(hours) %><sub>h</sub></h2>
      </div>
      <div class="column column-25">
        <h2><%=Util.count_display(minutes)%><sub>m</sub></h2>
      </div>
        <div class="column column-25">
          <h2><%=Util.count_display(seconds)%><sub>s</sub></h2>
        </div>
    </div>
     <%= raw display_timer_button(@start_timer, @stop_timer) %>
     <button phx-click="reset">Reset</button>
     </section>
    </div>
    <%# end %>

    <div class="column column-50 column-offset-10">
    <div class="container">
    <h1>Contest Scoreboard </h1>
    <table>
    <tr>
    <th>Player</th>
    <th>Score</th>
    <th>Bricks</th>
    <th>Questions</th>
    <th>Start time</th>
    <th>End time</th>
    <th>Date</th>
    </tr>

    <%= for record <- @contest_record do %>
     <tr>
    <td><%= record.user.name %></td>
    <td><%= record.score %></td>
    <td><%= record.dropped_bricks %></td>
    <td><%= record.correctly_answered_qna %></td>
    <td><%= Util.datetime_to_time(record.start_time) %></td>
    <td><%= Util.datetime_to_time(record.end_time) %></td>
    <td><%= Util.datetime_to_date(record.start_time) %></td>
    </tr>
    <% end %>

    </table>
    </div>
    <% else %>
      <div class="container">
     <section class="phx-hero">
    <h1>Contest countdown </h1>
    <div class="row">
    <div class="column column-25">
    <h2><%= @start_date |> Util.date_count() |> Util.count_display() %></h2>
    <h2>DAYS</h2>
    </div>
     <div class="column column-25">
    <h2><%= Util.count_display(@hours)%></h2>
    <h2>HOURS</h2>
    </div>
     <div class="column column-25">
    <h2><%=Util.count_display(@minutes)%></h2>
    <h2>MINUTES</h2>
    </div>
     <div class="column column-25">
    <h2><%=Util.count_display(@seconds)%></h2>
    <h2>SECONDS</h2>
    </div>
    </div>
    <h3>Contest coming soon, Time until 18th May 2021(UTC + 0) </h3>

    </section>
    </div>
    <% end %>
    """
  end

  def handle_event("timer", %{"timer" => "start"}, %{assigns: %{seconds: seconds}} = socket)
      when seconds > 0 do
    {:noreply, socket |> assign(running: true)}
  end

  def handle_event("timer", %{"timer" => "start"}, socket) do
    {:noreply,
     socket
     |> assign(
       running: true,
       start_time: DateTime.utc_now()
     )}
  end

  def handle_event("timer", %{"timer" => "stop"}, socket) do
    QuadquizaminosWeb.Endpoint.broadcast!(
      "contest_timer",
      "timer",
      {:stop_timer, true}
    )

    {:noreply, socket |> assign(running: false, end_time: DateTime.utc_now())}
  end

  def handle_event("timer", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("reset", _params, socket) do
    {:noreply,
     socket
     |> assign(
       running: false,
       seconds: 0
     )}
  end

  def handle_info(:timer, %{assigns: %{running: true, seconds: seconds}} = socket) do
    contest_record =
      socket.assigns.start_time
      |> Records.contest_game()

    {:noreply,
     socket
     |> assign(contest_record: contest_record, seconds: seconds + 1)}
  end

  def handle_info(:timer, socket) do
    contest_record =
      socket.assigns.start_time
      |> Records.contest_game(socket.assigns.end_time)

    {:noreply, socket |> assign(contest_record: contest_record)}
  end

  def handle_info(:count_down, socket) do
    seconds = second_count(socket.assigns.seconds)
    minutes = minute_count(socket.assigns.seconds, socket.assigns.minutes)
    hours = hour_count(socket.assigns.seconds, socket.assigns.minutes, socket.assigns.hours)

    {:noreply, socket |> assign(seconds: seconds, minutes: minutes, hours: hours)}
  end

  defp to_human_time(seconds) do
    hours = div(seconds, 3600)
    minutes = div(seconds - hours * 60, 60)
    seconds = div(seconds - minutes * 60, 1)
    {hours, minutes, seconds}
  end

  def current_time(start_date) do
    start_date |> DateTime.to_time()
  end

  defp current_hour(time) do
    @initial_hour - time.hour
  end

  defp current_minute(time) do
    @initial_minute - time.minute
  end

  defp current_second(time) do
    @initial_second - time.second
  end

  def second_count(0), do: @initial_second

  def second_count(seconds) do
    seconds - 1
  end

  def timer_second(59 = _seconds), do: 0

  def timer_second(seconds) do
    seconds + 1
  end

  def timer_minutes(59 = _seconds, minutes) do
    timer_minutes(minutes)
  end

  def timer_minutes(_seconds, minutes), do: minutes

  def timer_minutes(59 = _minutes), do: 0

  def timer_minutes(minutes) do
    minutes + 1
  end

  def timer_hours(59 = _seconds, 59 = _minutes, hours) do
    timer_hours(hours)
  end

  def timer_hours(_seconds, _minutes, hours), do: hours

  def timer_hours(23 = _hour), do: 0

  def timer_hours(hour) do
    hour + 1
  end

  defp minute_count(0 = _seconds, minutes) do
    minute_count(minutes)
  end

  defp minute_count(_seconds, minutes), do: minutes

  defp minute_count(0), do: @initial_minute

  defp minute_count(minutes), do: minutes - 1

  defp hour_count(59 = _seconds, 59 = _minutes, hours) do
    hour_count(hours)
  end

  defp hour_count(_seconds, _minutes, hours), do: hours

  defp hour_count(0 = _hours), do: @initial_hour

  defp hour_count(hours), do: hours - 1

  defp display_timer_button(true = _start_timer, false = _stop_timer) do
    """
     <button phx-click="timer" phx-value-timer="stop">Stop</button>
    """
  end

  defp display_timer_button(false = _start_timer, true = _stop_timer) do
    """
     <button phx-click="timer" phx-value-timer="start">Start</button>
    """
  end

  defp display_timer_button(_start_timer, _stop_timer) do
    """
     <button phx-click="timer" phx-value-timer="start">Start</button>
    """
  end
end
