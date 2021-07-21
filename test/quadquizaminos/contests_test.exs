defmodule Quadquizaminos.ContestsTest do
  use Quadquizaminos.DataCase
  alias Quadquizaminos.{Accounts, Contests}
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.GameBoard.Records

  describe "contest_game_records/1" do
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

    test "Fetches the game records of a given contest", %{contest: contest} do
      game_records = contest |> Contests.contest_game_records()
      assert game_records |> Enum.count() == 2

      assert Enum.all?(game_records, fn record ->
               record.start_time >= contest.start_time and record.end_time <= contest.end_time
             end)
    end
  end
end
