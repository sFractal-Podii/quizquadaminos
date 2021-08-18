defmodule Quadquizaminos.Repo.Migrations.AddContestDateToContests do
  use Ecto.Migration

  def change do
    alter table("contests") do
      add :contest_date, :utc_datetime_usec
    end
  end
end
