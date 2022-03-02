defmodule Quadblockquiz.Repo.Migrations.RectifyExistingUserRole do
  use Ecto.Migration

  def up do
    execute "
   UPDATE users
   SET role = CASE
              WHEN user_id IN (43263401, 1723279, 32665021, 584211)  THEN
              'admin'
              ELSE 'player'
              END
   "
  end

  def down do
  end
end
