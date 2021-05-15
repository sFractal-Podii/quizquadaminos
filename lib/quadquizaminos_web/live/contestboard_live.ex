defmodule QuadquizaminosWeb.ContestboardLive do
  use Phoenix.LiveView

  import Phoenix.HTML, only: [raw: 1]

  alias Quadquizaminos.Util
  alias Quadquizaminos.GameBoard.Records
  alias Phoenix.PubSub

  @conference_date Application.fetch_env!(:quadquizaminos, :conference_date)

  def mount(_params, session, socket) do
    :timer.send_interval(1000, self(), :count_down)
    :timer.send_interval(1000, self(), :timer)
    current_time = DateTime.utc_now()
    current_user = Map.get(session, "user_id")

    remaining_time = DateTime.diff(@conference_date, DateTime.utc_now())

    {:ok,
     socket
     |> assign(
       running: false,
       contest_record: [],
       contest_counter: 0,
       start_time: nil,
       end_time: nil,
       remaining_time: remaining_time,
       current_user: current_user
     )}
  end

  def render(assigns) do
    ~L"""
     <% {days, hours, minutes, seconds} = Util.to_human_time(@remaining_time) %>
     <%= if days == 0 do %>
      <h1>Contest Day</h1>
    <div class="row">
     <%#= if @current_user in Application.get_env(:quadquizaminos, :github_ids) do %>
      <div class="column column-25 column-offset-5">
        <section class="phx-hero">
        <h2>Timer</h2>
        <% {hours, minutes, seconds} = to_human_time(@contest_counter) %>
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
     <%= raw display_timer_button(@running) %>
     <button phx-click="reset">Reset</button>
     </section>
    </div>
    <%#= end %>

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
       contest_counter: 0
     )}
  end

  def handle_info(:timer, %{assigns: %{running: true, contest_counter: seconds}} = socket) do
    contest_record =
      socket.assigns.start_time
      |> Records.contest_game()

    IO.inspect(socket.assigns.start_time, label: "=============================")

    {:noreply,
     socket
     |> assign(contest_record: contest_record, contest_counter: seconds + 1)}
  end

  def handle_info(:timer, socket) do
    contest_record =
      socket.assigns.start_time
      |> Records.contest_game(socket.assigns.end_time)

    {:noreply, socket |> assign(contest_record: contest_record)}
  end

  def handle_info(:count_down, socket) do
    remaining_time = DateTime.diff(@conference_date, DateTime.utc_now())
    {:noreply, socket |> assign(remaining_time: remaining_time)}
  end

  defp to_human_time(seconds) do
    hours = div(seconds, 3600)
    rem = rem(seconds, 3600)
    minutes = div(rem, 60)
    rem = rem(rem, 60)
    seconds = div(rem, 1)
    {hours, minutes, seconds}
  end

  defp display_timer_button(true = _running) do
    """
     <button phx-click="timer" phx-value-timer="stop">Stop</button>
    """
  end

  defp display_timer_button(false = _running) do
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
