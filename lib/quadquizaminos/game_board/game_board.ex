defmodule Quadquizaminos.GameBoard do
  use Ecto.Schema
  import Ecto.Changeset

  alias Quadquizaminos.Accounts.User

  @type t :: %__MODULE__{}

  schema "game_boards" do
    field :start_time, :utc_datetime_usec
    field :end_time, :utc_datetime_usec
    belongs_to :user, User, foreign_key: :user_id, references: :user_id
    field :score, :integer
    field :dropped_bricks, :integer
    field :correctly_answered_qna, :integer
  end

  def changeset(board, attrs \\ %{}) do
    board
    |> cast(attrs, [
      :start_time,
      :end_time,
      :user_id,
      :score,
      :dropped_bricks,
      :correctly_answered_qna
    ])
  end
end
