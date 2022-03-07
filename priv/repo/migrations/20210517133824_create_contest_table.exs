defmodule Quadblockquiz.Repo.Migrations.CreateContestTable do
  use Ecto.Migration

  def change do
    create table(:contests) do
      add :start_time, :utc_datetime_usec
      add :end_time, :utc_datetime_usec
    end
  end
end
