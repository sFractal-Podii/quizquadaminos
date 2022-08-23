defmodule Quadblockquiz.Repo.Migrations.AddPowerupsCountToGameRecords do
  use Ecto.Migration

  def change do
    alter table(:game_boards) do
      add :powerups, :string
    end
  end
end
