defmodule QuadquizaminosWeb.LeaderboardLiveTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Quadquizaminos.Accounts
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.GameBoard.Records

  test "users can access leaderboard", %{conn: conn} do
    {:ok, _view, html} = live(conn, "/leaderboard")

    assert html =~ "<h1>Leaderboard</h1>"
  end

  test "top 10 games played are displayed", %{conn: conn} do
    Enum.each(1..15, fn num ->
      attrs = %{name: "Quiz Block ", user_id: num, role: "player"}
      {:ok, user} = Accounts.create_user(%User{}, attrs)

      game_record = %{
        start_time: ~U[2021-04-20 06:00:53Z],
        end_time: DateTime.utc_now(),
        user_id: user.user_id,
        score: 10 * num,
        dropped_bricks: 10,
        correctly_answered_qna: 2
      }

      Records.record_player_game(true, game_record)
    end)

    {:ok, _view, html} = live(conn, "/leaderboard")
    assert row_count(html) == 10
    assert html =~ "<th>Player</th>"
    assert html =~ "<th>Score</th>"
    assert html =~ "<th>Dropped Bricks</th>"
    assert html =~ "<th>Correctly Answered Qna</th>"
    assert html =~ "<th>Start time</th>"
    assert html =~ "<th>End time</th>"
    assert html =~ "<th>Date</th>"
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
