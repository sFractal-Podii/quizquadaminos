defmodule Quadquizaminos.Repo.Migrations.AlterContestsTable do
  use Ecto.Migration

  def change do
    alter table(:contests) do
      add :name, :string
    end
  end
end
