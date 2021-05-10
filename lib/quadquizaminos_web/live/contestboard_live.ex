defmodule QuadquizaminosWeb.ContestboardLive do
  use Phoenix.LiveView

  alias Quadquizaminos.Util

  @initial_hour 23
  @initial_minute 59
  @initial_second 59
  def mount(_params, _session, socket) do
    :timer.send_interval(1000, self(), :count_down)
    start_date = DateTime.utc_now()
    time = current_time(start_date)

    {:ok,
     socket
     |> assign(
       hours: current_hour(time),
       minutes: current_minute(time),
       seconds: current_second(time),
       start_date: start_date
     )}
  end

  def render(assigns) do
    ~L"""
    <div class="container">
    <section class="phx-hero">
    <%= if Util.date_count(@start_date) < 1 do %>
    <h1>Contest Day</h1>
    <% else %>
    <h1>Contest countdown </h1>
    <div class="row">
    <div class="column column-25">
    <h1><%= @start_date |> Util.date_count() |> Util.count_display() %></h1>
    <h1>DAYS</h1>
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
    <h3>Contest coming soon, Time until 05th May 2021 </h3>
    <% end %>
    </section>
    </div>
    """
  end

  def handle_info(:count_down, socket) do
    seconds = second_count(socket.assigns.seconds)
    minutes = minute_count(socket.assigns.seconds, socket.assigns.minutes)
    hours = hour_count(socket.assigns.seconds, socket.assigns.minutes, socket.assigns.hours)

    {:noreply, socket |> assign(seconds: seconds, minutes: minutes, hours: hours)}
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
end
