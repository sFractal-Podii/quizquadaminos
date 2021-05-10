defmodule QuadquizaminosWeb.ContestboardLive do
  use Phoenix.LiveView
  use Timex
  @initial_hour 23
  @initial_minute 59
  @initial_second 59
  def mount(_params, _session, socket) do
    :timer.send_interval(1000, self(), :count_down)
    start_date = DateTime.utc_now()
    time = current_time(start_date) 
    {:ok, socket |> assign(hours: current_hour(time), minutes: current_minute(time), seconds: current_second(time), start_date: start_date)}
  end

#Next step, use current hour, minutes and seconds

  def render(assigns) do
    ~L"""
    <h1>Contest coming soon </h1>
    <h2> Days <%=date_count(@start_date)%></h2>
    <h3> Hours <%=time_display(@hours)%></h3>
    <h3> Minutes <%=time_display(@minutes)%></h3>
    <h3> Seconds <%=time_display(@seconds)%></h3>
    """
  end

  def handle_info(:count_down, socket) do
    start_date = DateTime.utc_now |> IO.inspect
     seconds = second_count(socket.assigns.seconds) 
     new_minute = minute_count(socket, seconds)
     hours = hour_count(socket, socket.assigns.minutes)
    {:noreply, socket |> assign(seconds: seconds , minutes: new_minute, hours: hours, start_date: start_date)}
  end

  def date_count(start_date) do
    d_day_time = Application.fetch_env!(:quadquizaminos, :contest_date)
    Date.diff(DateTime.to_date(d_day_time), DateTime.to_date(start_date))
  end

  def current_time(start_date) do
    start_date |> DateTime.to_time 
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

  def second_count(seconds) do
    if seconds == 0 do
      @initial_second
    else
       seconds - 1
    end
  end

  defp time_display(time_count) do
    count = time_count |> Integer.digits() |> Enum.count()
    if count == 1 , do: "#{0}" <> "#{time_count}", else: "#{time_count}" 
  end


  def minute_count(socket, seconds)do
    if seconds == 0 do
      minute_count(socket.assigns.minutes)
    else 
      socket.assigns.minutes
    end
  end

  defp minute_count(minutes)do
      if minutes == 0 do
        @initial_minute
      else
        minutes - 1
      end
  end

  def hour_count(socket, minutes)do
    if minutes == 59 and socket.assigns.seconds == 0 do
      hour_count(socket.assigns.hours)
    else
      socket.assigns.hours 
    end
  end

  def hour_count(hours) do
    if hours == 0 do
      @initial_hour
    else
      hours - 1
    end
  end
end
