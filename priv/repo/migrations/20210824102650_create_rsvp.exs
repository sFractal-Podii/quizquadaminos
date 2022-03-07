defmodule Quadquizaminos.Repo.Migrations.CreateRsvp do
  use Ecto.Migration

  def change do
    create table("rsvps") do
      add :user_id, references(:users, column: :uid, type: :string), null: false
      add :contest_id, references(:contests), null: false

      timestamps()
    end

    create unique_index("rsvps", [:user_id, :contest_id])
  end
end
