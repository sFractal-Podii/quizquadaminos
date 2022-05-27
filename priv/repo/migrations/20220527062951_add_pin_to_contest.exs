defmodule Quadblockquiz.Repo.Migrations.AddPinToContest do
  use Ecto.Migration

  def change do
    alter table(:contests) do
      add :pin, :string
    end
  end
end
