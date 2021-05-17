defmodule QuadquizaminosWeb.ContestboardLive do
  use Phoenix.LiveView

  import Phoenix.HTML, only: [raw: 1]

  alias Quadquizaminos.Util
  alias Quadquizaminos.GameBoard.Records

  @conference_date Application.fetch_env!(:quadquizaminos, :conference_date)

  def mount(_params, session, socket) do
    :timer.send_interval(1000, self(), :count_down)
    :timer.send_interval(1000, self(), :timer)
    QuadquizaminosWeb.Endpoint.subscribe("scores")

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
       current_user: Map.get(session, "uid")
     )}
  end

  def render(assigns) do
    ~L"""
     <%= if @remaining_time <= 0  do %>
      <h1>Contest Day</h1>
    <div class="row">
     <%= if admin?(@current_user) do %>
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
      <button class="red" phx-click="timer" phx-value-timer="stop">Stop</button>
     <button phx-click="reset">Reset</button>
     <button phx-click="final-score">Final Results</button>
     </section>
    </div>
    <%= end %>

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
     <td> <%= user_name(record) %></td>
    <td><%= record.score %></td>
    <td><%= record.dropped_bricks %></td>
    <td><%= record.correctly_answered_qna %></td>
    <td><%= Util.datetime_to_time(record.start_time) %></td>
    <td><%= Util.datetime_to_time(Map.get(record,:end_time)) %></td>
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
    <% {days, hours, minutes, seconds} = Util.to_human_time(@remaining_time) %>

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
    <h3>Contest coming soon, Contest starts: 11:40 PDT on 18th May 2021 </h3>

    </section>
    </div>
    <% end %>
    """
  end

  defp admin?(current_user) do
    ids = Application.get_env(:quadquizaminos, :github_ids)

    current_user in (ids |> Enum.map(&(&1 |> to_string())))
  end

  defp user_name(record) do
    case record do
      %Quadquizaminos.GameBoard{} ->
        record.user.name

      _ ->
        case Quadquizaminos.Accounts.get_user(record.uid) do
          nil -> "Anonymous"
          user -> user.name
        end
    end
  end

  defp user_name(%Quadquizaminos.Accounts.User{} = user, _uid), do: user.name

  def handle_event(
        "timer",
        %{"timer" => "start"},
        %{assigns: %{contest_counter: seconds, end_time: nil}} = socket
      )
      when seconds > 0 do
    {:noreply, socket |> assign(running: true)}
  end

  def handle_event("timer", %{"timer" => "start"}, socket) do
    start_time = DateTime.utc_now()
    Records.create_contest(%{start_time: start_time})

    {:noreply,
     socket
     |> assign(
       running: true,
       start_time: start_time
     )}
  end

  def handle_event("timer", %{"timer" => "pause"}, socket) do
    {:noreply, socket |> assign(running: false)}
  end

  def handle_event("timer", %{"timer" => "stop"}, socket) do
    {_hours, minutes, seconds} = to_human_time(socket.assigns.contest_counter)
    end_time = DateTime.utc_now()

    Records.latest_contest() |> Records.update_contest(%{end_time: end_time})

    QuadquizaminosWeb.Endpoint.broadcast!(
      "contest_timer",
      "timer",
      {:stop_timer, true}
    )

    {:noreply,
     socket
     |> assign(running: false, end_time: end_time)}
  end

  def handle_event("timer", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("final-score", _, socket) do
    latest_contest = Records.latest_contest()

    contest_record =
      latest_contest.start_time
      |> Records.contest_game(latest_contest.end_time)

    {:noreply, socket |> assign(contest_record: contest_record)}
  end

  def handle_event("reset", _params, socket) do
    {:noreply,
     socket
     |> assign(
       running: false,
       contest_counter: 0
     )}
  end

  def handle_info(
        %{event: "current_score", payload: payload},
        %{assigns: %{running: true}} = socket
      ) do
    contest_record = socket.assigns.contest_record

    contest_record =
      (contest_record ++ [payload])
      |> Enum.sort_by(& &1.score, :desc)
      |> Enum.uniq_by(& &1.uid)
      |> Enum.take(10)

    {:noreply, socket |> assign(contest_record: contest_record)}
  end

  def handle_info(%{event: "current_score", payload: _payload}, socket) do
    {:noreply, socket}
  end

  def handle_info(:timer, %{assigns: %{running: true, contest_counter: seconds}} = socket) do
    {:noreply, socket |> assign(contest_counter: seconds + 1)}
  end

  def handle_info(:timer, socket) do
    {:noreply, socket}
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
     <button phx-click="timer" phx-value-timer="pause">Pause</button>
    """
  end

  defp display_timer_button(false = _running) do
    """
     <button phx-click="timer" phx-value-timer="start">Start</button>
    """
  end
end
