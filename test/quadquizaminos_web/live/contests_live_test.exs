defmodule QuadquizaminosWeb.ContestsLiveTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest
  alias Quadquizaminos.Contests

setup %{conn: conn} do
  Contests.create_contest(%{name: "ContestC"})
  conn = get(conn, "/contests")
  [conn: conn]
end

test "admin can access the contest page", %{conn: conn} do
  assert html_response(conn, 200) =~ "<h1>Contests</h1>"
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

test "admin can create a contest", %{conn: conn} do
  {:ok, view, _html} = live(conn, "/contests")

  html = render_keydown(view, :save, %{"key" => "Enter", "value" => "ContestD"})

  assert html =~ "<td>ContestD</td>" && "<td>ContestC</td>"
end

test "admin can see the timer", %{conn: conn}do
  conn = get(conn, "/contests")
  assert html_response(conn, 200) =~ "<p>00:00:00</p>"
end

end
