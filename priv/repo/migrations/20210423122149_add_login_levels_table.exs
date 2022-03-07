defmodule QuadBlockQuiz.Repo.Migrations.AddLoginLevelsTable do
  use Ecto.Migration

  def up do
    create table(:login_levels, primary_key: false) do
      add :name, :string, primary_key: true
      add :active, :boolean, default: false
    end

    execute "
    insert into login_levels values 
    ('by_config'), ('oauth_login'), ('anonymous_login');
    "
  end

  def down do
    drop table(:login_levels)
  end
end
