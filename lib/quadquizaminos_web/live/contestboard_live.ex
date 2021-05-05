defmodule QuadquizaminosWeb.ContestboardLive do
  use Phoenix.LiveView
  use Timex
  def mount(_params, _session, socket) do
    :timer.send_interval(1000, self(), :count_down)
    {:ok, socket |> assign(hours: 2, minutes: 5, seconds: 5 , start_date: DateTime.utc_now())}
  end

  def render(assigns) do
    ~L"""
    <h1>Contest coming soon </h1>
    <h2> Days <%=date_count(@start_date)%></h2>
    <h3> Hours <%=@hours%></h3>
    <h3> Minutes <%=@minutes%></h3>
    <h3> Seconds <%=@seconds%></h3>
    """
  end

  def handle_info(:count_down, socket) do
    IO.inspect(socket.assigns.start_date)
    
     seconds = second_count(socket.assigns.seconds)
     new_minute = minute_count(socket, seconds)
     hours = hour_count(socket, socket.assigns.minutes)
     IO.inspect(new_minute , label: "=====new========")
    {:noreply, socket |> assign(seconds: seconds , minutes: new_minute, hours: hours)}
  end

  def date_count(start_date) do
    d_day_time = Application.fetch_env!(:quadquizaminos, :contest_date)
    Date.diff(DateTime.to_date(d_day_time), DateTime.to_date(start_date))
  end

  def second_count(seconds) do
    if seconds == 0 do
      5
    else
       seconds - 1
    end
  end

  def minute_count(socket, seconds)do
    if seconds == 0 do
      socket.assigns.minutes - 1
    else 
      socket.assigns.minutes
    end
  end

    def hour_count(socket, minutes)do
      if minutes == 0 do
        socket.assigns.hours - 1
      else
        socket.assigns.hours 
      end
    end
end
