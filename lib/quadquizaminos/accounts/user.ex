defmodule Quadquizaminos.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Quadquizaminos.GameBoard

  @primary_key false
  schema "users" do
    field :uid, :string, primary_key: true
    field :name, :string
    field :avatar, :string
    field :role, :string
    field :provider, :string
    field :email, :string
    field :admin?, :boolean, virtual: true
    has_many :game_boards, GameBoard, foreign_key: :uid, references: :uid
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:uid, :name, :avatar, :role, :provider, :email])
    |> validate_format(
      :email,
      ~r/^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|
      (\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i
    )
  end

  def email_changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email])
  end
end
