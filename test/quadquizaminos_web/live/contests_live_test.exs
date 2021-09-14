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
    {:ok, _view, html} = live(conn, "/contests")

    assert html =~ "<button class=\"  icon-button\" phx-click=\"start\""
    assert html =~ "<button class=\"disabled  icon-button\" phx-click=\"stop\""
  end

  test "admin can access the contest page", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/contests")
    assert html =~ "<h1>Contests</h1>"
  end

  test "admin can start a contest", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/contests")

    html = render_click(view, :start, %{"contest" => "ContestC"})
    contest = Contests.get_contest("ContestC")
    assert html =~ "<td>#{DateTime.truncate(contest.start_time, :second)}</td>"
  end

  test "admin can stop a contest", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/contests")

    render_click(view, :start, %{"contest" => "ContestC"})
    html = render_click(view, :stop, %{"contest" => "ContestC"})
    contest = Contests.get_contest("ContestC")

    assert html =~ "Final Results"
    assert html =~ "<td>#{DateTime.truncate(contest.end_time, :second)}</td>"
  end

  test "only admin can see option to create contest", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/contests")

    assert html =~ "<input type=\"text\""
  end

  test "admin can create a contest", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/contests")

    html = render_keydown(view, :save, %{"key" => "Enter", "value" => "ContestD"})
    assert row_count(html) == 2
    assert html =~ "<td>ContestD</td>"
  end

  test "admin can see the count up timer increase", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/contests")
    assert ContestAgent.time_elapsed("ContestC") == 0
    render_click(view, :start, %{"contest" => "ContestC"})
    assert render(view) =~ "00:00:00"
    Process.sleep(1000)
    send(view.pid, :timer)
    assert ContestAgent.time_elapsed("ContestC") == 1
    assert render(view) =~ "00:00:01"
  end

  test "admin can see the timer", %{conn: conn} do
    conn = get(conn, "/contests")
    assert html_response(conn, 200) =~ "<td>\n\n\n<p>00:00:00</p>\n\n\n"
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

  defp row_count(html) do
    row =
      ~r/<tr>/
      |> Regex.scan(html)
      |> Enum.count()

    # row is deducted by 2 due to the <tr> for table head and also <tr> for footer
    row - 2
  end
end
