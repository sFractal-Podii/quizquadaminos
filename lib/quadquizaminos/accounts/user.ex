defmodule Quadquizaminos.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key false
  schema "users" do
    field :user_id, :integer, primary_key: true
    field :name, :string
    field :avatar, :string
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:user_id, :name, :avatar])
  end
end
