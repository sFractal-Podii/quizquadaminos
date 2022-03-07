defmodule QuadBlockQuiz.Repo.Migrations.AddBottomToGameBoards do
  use Ecto.Migration

  def change do
    alter table("game_boards") do
      add :bottom_blocks, :map
    end
  end
end
