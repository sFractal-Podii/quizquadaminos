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
    assert html =~ "class=\"heading-1\">Contests</div>"
  end

  test "only admin can see the start, stop button", %{conn: conn} do
    Contests.create_contest(%{name: "contestA"})
    # admin
    {:ok, _view, html} = live(conn, "/admin/contests")
    assert html =~ "icon-button\" phx-click=\"start\""
    assert html =~ "icon-button\" phx-click=\"stop\""
    # player
    conn = Auth.login("github:player")
    {:ok, _view, html} = live(conn, "/contests")
    refute html =~ "icon-button\" phx-click=\"start\""
    refute html =~ "icon-button\" phx-click=\"stop\""
  end

  test "admin can start a contest", %{conn: conn} do
    Contests.create_contest(%{name: "contestE"})
    {:ok, view, _html} = live(conn, "/admin/contests")
    html = render_click(view, :start, %{"contest" => "contestE"})
    contest = Contests.get_contest("contestE")
    assert html =~ "#{DateTime.truncate(contest.start_time, :second) |> DateTime.to_iso8601()}"
  end

  test "admin can stop a contest", %{conn: conn} do
    Contests.create_contest(%{name: "contestE"})
    {:ok, view, _html} = live(conn, "/admin/contests")
    render_click(view, :start, %{"contest" => "contestE"})
    html = render_click(view, :stop, %{"contest" => "contestE"})
    contest = Contests.get_contest("contestE")
    assert html =~ "Final Results"
    assert html =~ "#{DateTime.truncate(contest.start_time, :second) |> DateTime.to_iso8601()}"
  end

  test "User can see the rsvp button", %{conn: conn} do
    Contests.create_contest(%{name: "contestF"})
    {:ok, _view, html} = live(conn, "/contests")
    assert html =~ "RSVP\n  </button>"
  end

  test "User can rsvp for a contest", %{conn: conn} do
    Contests.create_contest(%{name: "contestG"})
    {:ok, view, _html} = live(conn, "/contests")

    html =
      view
      |> element("button", "RSVP")
      |> render_click()

    assert html =~ " CANCEL RSVP\n  </button>"
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

    assert html =~ "RSVP\n  </button>"
  end

  test "only admin can see option to create contest and set date", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/admin/contests")

    assert html =~
             "<input id=\"contest_name\" name=\"contest[name]\" placeholder=\"contest-name\" type=\"text\"/></div>"

    assert html =~
             "<input class=\"w-full\" id=\"contest_contest_date\" name=\"contest[contest_date]\" type=\"datetime-local\"/>"
  end

  test "admin can create a contest and set the date for the contest", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/admin/contests")

    render_submit(view, :save, %{
      "contest" => %{"name" => "ContestD", "contest_date" => "2021-09-16T14:11", "pin" => "1234"}
    })

    {:ok, _view, html} = live(conn, "/admin/contests")
    contest = Contests.get_contest("ContestD")
    assert row_count(html) == 1
    assert contest.name == "ContestD"
    assert contest.contest_date == ~U[2021-09-16 14:11:00.000000Z]
  end

  test "admin can see the timer after starting the contest", %{conn: conn} do
    Contests.create_contest(%{name: "contestB"})
    {:ok, view, _html} = live(conn, "/admin/contests")

    html = render_click(view, :start, %{"contest" => "contestB"})
    assert html =~ "00:00:00"
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

    assert html =~ "#{day} days #{hours}h #{minutes}m #{seconds}s"
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
      ~r/md:table-header-group/
      |> Regex.scan(html)
      |> Enum.count()

    row
  end
end
