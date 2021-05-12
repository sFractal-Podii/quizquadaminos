defmodule Quadquizaminos.Repo.Migrations.UpdateUserId do
  use Ecto.Migration

  def up do
    rename table(:users), :user_id, to: :uid
    rename table(:game_boards), :user_id, to: :uid

    drop(constraint(:game_boards, "game_boards_user_id_fkey"))
    alter table(:users) do
      modify :uid, :string
      add :provider, :string
    end

    alter table(:game_boards)do
      modify :uid, references("users", column: :uid, type: :string), on_delete: :delete_all
    end
  end

  def down do
    rename table(:users), :uid, to: :user_id
    rename table(:game_boards), :uid, to: :user_id

    drop(constraint(:game_boards, "game_boards_uid_fkey"))
    execute """
        alter table users alter column user_id type integer using (user_id::integer)
      """

    execute """
        alter table game_boards alter column user_id type integer using (user_id::integer)
      """

    alter table(:game_boards)do
      modify :user_id, references("users", column: :user_id), on_delete: :delete_all
    end
    
    alter table(:users) do
      remove :provider
    end
  end
end
