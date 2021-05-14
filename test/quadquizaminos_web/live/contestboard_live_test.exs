defmodule QuadquizaminosWeb.ContestboardLiveTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Quadquizaminos.Util
  alias Quadquizaminos.Test.Auth

  test "counts days/hours/minutes/seconds to a date supplied", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/contestboard")

    hour = 23 - current_time().hour
    minutes = 59 - current_time().minute
    seconds = 59 - current_time().second
    start_date = DateTime.utc_now()

    if Util.date_count(start_date) < 1 do
      assert html =~ "<h1>Contest Day</h1>"
    else
      assert html =~ "<h1>Contest countdown </h1>"

      assert html =~
               "<h2>#{start_date |> Util.date_count() |> Util.count_display()}</h2><h2>DAYS</h2>"

      assert html =~ "<h2>#{hour |> Util.count_display()}</h2><h2>HOURS</h2>"
      assert html =~ "<h2>#{minutes |> Util.count_display()}</h2><h2>MINUTES</h2>"
      assert html =~ "<h2>#{seconds |> Util.count_display()}</h2><h2>SECONDS</h2>"
    end
  end

  test "only admins can see contest timer when countdown is 0", %{conn: conn} do
    conn = Auth.login()
    {:ok, _view, html} = live(conn, "/contestboard")
    start_date = DateTime.utc_now()

    if Util.date_count(start_date) < 1 do
      assert html =~ "<h2>Timer</h2>"
      assert html =~ "<h2>00<sub>h</sub></h2>"
      assert html =~ "<h2>00<sub>m</sub></h2>"
      assert html =~ "<h2>00<sub>s</sub></h2>"
    end
  end

  test "admin can start and stop timer", %{conn: conn} do
    conn = Auth.login()
    {:ok, view, _html} = live(conn, "/contestboard")
    start_date = DateTime.utc_now()

    if Util.date_count(start_date) < 1 do
      html = render_click(view, "timer", %{"timer" => "start"})
      assert html =~ "Stop</button>"
      html = render_click(view, "timer", %{"timer" => "stop"})
      assert html =~ "Start</button>"
    end
  end

  defp current_time do
    DateTime.utc_now() |> DateTime.to_time()
  end
end
