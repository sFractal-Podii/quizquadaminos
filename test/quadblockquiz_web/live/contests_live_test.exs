defmodule QuadblockquizWeb.ContestsLiveTest do
  use QuadblockquizWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Quadblockquiz.Contests
  alias Quadblockquiz.{Contests, Util}
  alias Quadblockquiz.Test.Auth

  setup do
    conn = Auth.login()
    [conn: conn]
  end

  test "admin can access the contest page", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin/contests")
    assert html =~ "<h1>Contests</h1>"
  end

  test "only admin can see the start, stop button", %{conn: conn} do
    Contests.create_contest(%{name: "contestA"})
    # admin
    {:ok, _view, html} = live(conn, "/admin/contests")
    assert html =~ "<button class=\"  icon-button\" phx-click=\"start\""
    assert html =~ "<button class=\"disabled  icon-button\" phx-click=\"stop\""
    # player
    conn = Auth.login("github:player")
    {:ok, _view, html} = live(conn, "/contests")
    refute html =~ "<button class=\"  icon-button\" phx-click=\"start\""
    refute html =~ "<button class=\"disabled  icon-button\" phx-click=\"stop\""
  end

  test "admin can start a contest", %{conn: conn} do
    Contests.create_contest(%{name: "contestE"})
    {:ok, view, _html} = live(conn, "/admin/contests")
    html = render_click(view, :start, %{"contest" => "contestE"})
    contest = Contests.get_contest("contestE")
    assert html =~ "#{DateTime.truncate(contest.start_time, :second)}</td>"
  end

  test "admin can stop a contest", %{conn: conn} do
    Contests.create_contest(%{name: "contestE"})
    {:ok, view, _html} = live(conn, "/admin/contests")
    render_click(view, :start, %{"contest" => "contestE"})
    html = render_click(view, :stop, %{"contest" => "contestE"})
    contest = Contests.get_contest("contestE")
    assert html =~ "Final Results"
    assert html =~ "#{DateTime.truncate(contest.end_time, :second)}</td>"
  end

  test "User can see the rsvp button", %{conn: conn} do
    Contests.create_contest(%{name: "contestF"})
    {:ok, _view, html} = live(conn, "/contests")
    assert html =~ "RSVP </button>"
  end

  test "User can rsvp for a contest", %{conn: conn} do
    Contests.create_contest(%{name: "contestG"})
    {:ok, view, _html} = live(conn, "/contests")

    html =
      view
      |> element("button", "RSVP")
      |> render_click()

    assert html =~ "CANCEL RSVP </button>"
  end

  test "User can cancel a rsvp for a contest", %{conn: conn} do
    Contests.create_contest(%{name: "contestk"})
    {:ok, view, _html} = live(conn, "/contests")
    # RSVP a contest
    view
    |> element("button", "RSVP")
    |> render_click()

    # Cancel a contest RSVP
    html =
      view
      |> element("button", "CANCEL RSVP")
      |> render_click()

    assert html =~ "RSVP </button>"
  end

  test "admin can see the restart button", %{conn: conn} do
    Contests.create_contest(%{name: "contestE"})
    {:ok, view, _html} = live(conn, "/admin/contests")
    html = render_click(view, :start, %{"contest" => "contestE"})
    assert html =~ "<button class=\" icon-button\" phx-click=\"restart\""
  end

  test "only admin can see option to create contest and set date", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin/contests")

    assert html =~ "<input id=\"contest_name\" name=\"contest[name]\" type=\"text\""
    assert html =~ "type=\"datetime-local\"/></div>"
  end

  test "admin can create a contest and set the date for the contest", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/admin/contests")

    render_submit(view, :save, %{
      "contest" => %{"name" => "ContestD", "contest_date" => "2021-09-16T14:11"}
    })

    {:ok, _view, html} = live(conn, "/admin/contests")
    contest = Contests.get_contest("ContestD")
    assert row_count(html) == 2
    assert contest.name == "ContestD"
    assert contest.contest_date == ~U[2021-09-16 14:11:00.000000Z]
  end

  test "admin can see the timer after starting the contest", %{conn: conn} do
    Contests.create_contest(%{name: "contestB"})
    {:ok, view, _html} = live(conn, "/admin/contests")

    html = render_click(view, :start, %{"contest" => "contestB"})
    assert html =~ "<p>00:00:00</p>"
  end

  test "admin can see countdown timer", %{conn: conn} do
    {:ok, contestc} = Contests.create_contest(%{name: "contestc"})
    {:ok, _view, _html} = live(conn, "/admin/contests")

    {:ok, contestc} =
      Contests.update_contest(contestc, %{
        contest_date: DateTime.add(DateTime.utc_now(), 3600 * 3, :second)
      })

    {:ok, _view, html} = live(conn, "/admin/contests")

    countdown_interval = DateTime.diff(contestc.contest_date, DateTime.utc_now())
    {days, hour, minutes, seconds} = Util.to_human_time(countdown_interval)
    day = Util.count_display(days)
    hours = Util.count_display(hour)
    minutes = Util.count_display(minutes)
    seconds = Util.count_display(seconds)

    assert html =~ "<p>#{day} days #{hours}h #{minutes}m #{seconds}s</p>"
  end

  test "admin can see the count up timer increase", %{conn: conn} do
    Contests.create_contest(%{name: "contestJ"})
    {:ok, view, _html} = live(conn, "/admin/contests")
    render_click(view, :start, %{"contest" => "contestJ"})
    Process.sleep(1000)
    {:ok, _view, html} = live(conn, "/admin/contests")
    send(view.pid, :timer)
    assert html =~ "00:00:01"
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
