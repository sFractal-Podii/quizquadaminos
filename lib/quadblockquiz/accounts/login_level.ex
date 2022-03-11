defmodule Quadblockquiz.Accounts.LoginLevel do
  use Ecto.Schema

  import Ecto.Query

  @primary_key false
  schema "login_levels" do
    field :name, :string, primary_key: true
    field :active, :boolean
  end

  def base_query do
    from(l in __MODULE__)
  end

  def by_name(query, login_level) do
    from q in query,
      where: q.name == ^login_level
  end

  def selected_level do
    from l in __MODULE__,
      where: l.active
  end
end
