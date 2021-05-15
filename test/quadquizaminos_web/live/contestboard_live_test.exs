defmodule QuadquizaminosWeb.ContestboardLiveTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Quadquizaminos.Util
  alias Quadquizaminos.Test.Auth

  setup do
    conference_date = Application.fetch_env!(:quadquizaminos, :conference_date)
    remaining_time = DateTime.diff(conference_date, DateTime.utc_now())

    [remaining_time: remaining_time]
  end

  test "counts days/hours/minutes/seconds to a date supplied", %{
    conn: conn,
    remaining_time: remaining_time
  } do
    {:ok, _view, html} = live(conn, "/contestboard")

    {days, hour, minutes, seconds} = Util.to_human_time(remaining_time)

    if remaining_time == 0 do
      assert html =~ "<h1>Contest Day</h1>"
    else
      assert html =~ "<h1>Contest countdown </h1>"

      assert html =~
               "<h2>#{days |> Util.count_display()}</h2><h2>DAYS</h2>"

      assert html =~ "<h2>#{hour |> Util.count_display()}</h2><h2>HOURS</h2>"
      assert html =~ "<h2>#{minutes |> Util.count_display()}</h2><h2>MINUTES</h2>"
      assert html =~ "<h2>#{seconds |> Util.count_display()}</h2><h2>SECONDS</h2>"
    end
  end

  test "only admins can see contest timer when countdown is 0", %{
    remaining_time: remaining_time
  } do
    conn = Auth.login()
    {:ok, _view, html} = live(conn, "/contestboard")

    if remaining_time == 0 do
      assert html =~ "<h2>Timer</h2>"
      assert html =~ "<h2>00<sub>h</sub></h2>"
      assert html =~ "<h2>00<sub>m</sub></h2>"
      assert html =~ "<h2>00<sub>s</sub></h2>"
    end
  end

  test "admin can start and stop timer", %{remaining_time: remaining_time} do
    conn = Auth.login()
    {:ok, view, _html} = live(conn, "/contestboard")

    if remaining_time == 0 do
      html = render_click(view, "timer", %{"timer" => "start"})
      assert html =~ "Stop</button>"
      html = render_click(view, "timer", %{"timer" => "stop"})
      assert html =~ "Start</button>"
    end
  end
end
