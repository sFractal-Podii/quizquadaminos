defmodule Quadquizaminos.Repo.Migrations.CreateUserTable do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :user_id, :integer, primary_key: true
      add :name, :string
      add :avatar, :string
    end
  end
end
