defmodule QuadquizaminosWeb.ContestboardLiveTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Quadquizaminos.Util

  test "users can access contestboard", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/contestboard")

    assert html =~ "<h1>Contest countdown </h1>"
  end

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
               "<h1>#{start_date |> Util.date_count() |> Util.count_display()}</h1><h1>DAYS</h1>"

      assert html =~ "<h2>#{hour |> Util.count_display()}</h2><h2>HOURS</h2>"
      assert html =~ "<h2>#{minutes |> Util.count_display()}</h2><h2>MINUTES</h2>"
      assert html =~ "<h2>#{seconds |> Util.count_display()}</h2><h2>SECONDS</h2>"
    end
  end

  defp current_time do
    DateTime.utc_now() |> DateTime.to_time()
  end
end
