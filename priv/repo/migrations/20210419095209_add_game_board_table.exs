defmodule Quadquizaminos.Repo.Migrations.AddGameBoardTable do
  use Ecto.Migration

  def change do
    create table("game_boards") do
      add :start_time, :date
      add :end_time, :date
      add :user_id, references("users", column: :user_id), on_delete: :delete_all
      add :score, :integer
      add :dropped_bricks, :integer
      add :answered_question, :integer
    end
  end
end
