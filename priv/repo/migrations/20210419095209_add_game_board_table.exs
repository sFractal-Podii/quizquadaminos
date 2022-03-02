defmodule Quadblockquiz.Repo.Migrations.AddGameBoardTable do
  use Ecto.Migration

  def change do
    create table("game_boards") do
      add :start_time, :utc_datetime_usec
      add :end_time, :utc_datetime_usec
      add :user_id, references("users", column: :user_id), on_delete: :delete_all
      add :score, :integer
      add :dropped_bricks, :integer
      add :correctly_answered_qna, :integer
    end
  end
end
