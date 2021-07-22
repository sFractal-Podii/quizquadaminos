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
  assert row_count(html) == 2
  assert html =~ "<td>ContestD</td>"


end

test "admin can see the timer", %{conn: conn}do
  conn = get(conn, "/contests")
  assert html_response(conn, 200) =~ "<td>\n\n\n<p>00:00:00</p>\n\n\n"
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
