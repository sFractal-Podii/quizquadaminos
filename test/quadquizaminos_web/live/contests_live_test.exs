defmodule QuadquizaminosWeb.ContestsLiveTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Quadquizaminos.Contest.ContestAgent
  alias Quadquizaminos.{Contests, Util}
  alias Quadquizaminos.Test.Auth

  setup do
    Contests.create_contest(%{name: "ContestC"})
    conn = Auth.login()
    [conn: conn]
  end

  test "only admin can see the start, stop button", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin/contests")
    assert html =~ "<button class=\"  icon-button\" phx-click=\"start\""
    assert html =~ "<button class=\"disabled  icon-button\" phx-click=\"stop\""
  end

  test "admin can access the contest page", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin/contests")
    assert html =~ "<h1>Contests</h1>"
  end

  test "admin can start a contest", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/admin/contests")

    html = render_click(view, :start, %{"contest" => "ContestC"})
    contest = Contests.get_contest("ContestC")
    assert html =~ "#{DateTime.truncate(contest.start_time, :second)}</td>"
  end

  test "admin can stop a contest", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/admin/contests")

    render_click(view, :start, %{"contest" => "ContestC"})
    html = render_click(view, :stop, %{"contest" => "ContestC"})
    contest = Contests.get_contest("ContestC")
    IO.inspect(html)
    assert html =~ "Final Results"
    assert html =~ "#{DateTime.truncate(contest.end_time, :second)}</td>"
  end

  test "only admin can see option to create contest and set date", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin/contests")

    assert html =~ "<input type=\"text\""
    assert html =~ "<input type=\"datetime-local\""
  end

  test "admin can create a contest and set the date for the contest", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/admin/contests")

    html = render_click(view, :save, %{"name" => "ContestD", "contest_date" => "2021-09-16T14:11"})
    assert row_count(html) == 3
    assert html =~ "ContestD</td>"
    assert html =~ "2021-09-16 14:11:00Z\n"
  end

  test "admin can see the count up timer increase", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/admin/contests")
     assert ContestAgent.time_elapsed("ContestC") == 0
     render_click(view, :start, %{"contest" => "ContestC"})
     assert render(view) =~ "00:00:00"
     Process.sleep(1000)
     send(view.pid, :timer)
     assert ContestAgent.time_elapsed("ContestC") == 1
     assert render(view) =~ "00:00:01"
  end

  test "admin can see the timer after starting the contest", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/admin/contests")

    html = render_click(view, :start, %{"contest" => "ContestC"})
    assert html =~ "<p>00:00:00</p>"
  end

  test "countdown timer is shown before contest date", %{conn: conn} do
    conference_date = Application.fetch_env!(:quadquizaminos, :conference_date)
    countdown_interval = DateTime.diff(conference_date, DateTime.utc_now())
    {:ok, _view, html} = live(conn, "/admin/contests")

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

  defp row_count(html) do
    row =
      ~r/<tr>/
      |> Regex.scan(html)
      |> Enum.count()

    # row is deducted by 2 due to the <tr> for table head and also <tr> for footer
    row - 2
  end
end
