defmodule QuadquizaminosWeb.ContestsLiveShowTest do
  use QuadquizaminosWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Quadquizaminos.{Accounts, Contests}
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.GameBoard.Records

  setup do
    attrs = %{name: "Quiz Block ", uid: Integer.to_string(40_000_000), role: "admin"}
    {:ok, user} = Accounts.create_user(%User{}, attrs)

    {:ok, contest} =
      Contests.create_contest(%{
        end_time: ~U[2021-07-21 17:59:59.000000Z],
        start_time: ~U[2021-07-21 15:59:59.000000Z],
        name: "contestA"
      })

    Enum.each(1..3, fn x ->
      game_attr = %{
        contest_id: contest.id,
        correctly_answered_qna: 0,
        dropped_bricks: 10,
        end_time: DateTime.add(~U[2021-07-21 15:59:59.000000Z], 3600 * x, :second),
        score: 101,
        start_time: DateTime.add(~U[2021-07-21 14:59:59.000000Z], 3600 * x, :second),
        uid: user.uid
      }

      Records.create_record(game_attr)
    end)

    [contest: contest]
  end

  test "players can view contest final results", %{conn: conn, contest: contest} do
    {:ok, _view, html} = live(conn, "/contests/#{contest.id}")

    assert row_count(html) == 2
    assert html =~ "<h1>Contestboard</h1>"
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
