defmodule QuadquizaminosWeb.ContestsLiveShowTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Quadquizaminos.{Contests, Util}
  alias Quadquizaminos.Test.Auth

  setup do
    Contests.create_contest(%{
      name: "contestA"
    })

    :ok
  end

  test "only admin can see the start, stop button" do
    conn = Auth.login()
    {:ok, _view, html} = live(conn, "/contests")


    assert html =~ "<button class=\"  icon-button\" phx-click=\"start\""
    assert html =~ "<button class=\"disabled  icon-button\" phx-click=\"stop\""
  end

  test "only admin can see option to create contest" do
    conn = Auth.login()
    {:ok, _view, html} = live(conn, "/contests")

    assert html =~ "<input type=\"text\""
  end

  test "countdown timer is shown before contest date", %{conn: conn} do
    conference_date = Application.fetch_env!(:quadquizaminos, :conference_date)
    countdown_interval = DateTime.diff(conference_date, DateTime.utc_now())
    {:ok, _view, html} = live(conn, "/contests")

    {days, hour, minutes, seconds} = Util.to_human_time(countdown_interval)

    if countdown_interval <= 0 do
      assert html =~ "<h1>Contests</h1>"
    else
      assert html =~ "<h1>Contest countdown </h1>"

      assert html =~
               "<h2>#{days |> Util.count_display()}</h2><h2>DAYS</h2>"

      assert html =~ "<h2>#{hour |> Util.count_display()}</h2><h2>HOURS</h2>"
      assert html =~ "<h2>#{minutes |> Util.count_display()}</h2><h2>MINUTES</h2>"
      assert html =~ "<h2>#{seconds |> Util.count_display()}</h2><h2>SECONDS</h2>"
    end
  end
end
