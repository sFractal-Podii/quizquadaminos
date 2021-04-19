defmodule Quadquizaminos.GameBoard do
  use Ecto.Schema

  alias Quadquizaminos.Accounts.User

  schema "game_boards" do
    field :start_time, :date
    field :end_time, :date
    belongs_to :user, User, foreign_key: :user_id, references: :user_id
    field :score, :integer
    field :dropped_bricks, :integer
    field :answered_question, :integer
  end
end
