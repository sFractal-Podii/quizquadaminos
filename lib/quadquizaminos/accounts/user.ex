defmodule Quadquizaminos.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  alias Quadquizaminos.GameBoard

  @primary_key false
  schema "users" do
    field :user_id, :integer, primary_key: true
    field :name, :string
    field :avatar, :string
    field :role, :string
    has_many :game_boards, GameBoard, foreign_key: :user_id, references: :user_id
  end

  def changeset(user, attrs \\ %{}) do
    user
    |> cast(attrs, [:user_id, :name, :avatar, :role])
  end
end
