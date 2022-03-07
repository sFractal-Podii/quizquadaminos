defmodule Quadblockquiz.Repo.Migrations.AlterGameRecords do
  use Ecto.Migration

  def change do
    alter table("game_boards") do
      add :contest_id, references(:contests)
    end
  end
end
