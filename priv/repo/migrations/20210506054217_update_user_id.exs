defmodule Quadquizaminos.Repo.Migrations.UpdateUserId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      rename :user_id, :string
    end
  end
end
