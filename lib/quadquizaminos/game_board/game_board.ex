defmodule Quadquizaminos.GameBoard do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Quadquizaminos.Accounts.User

  @type t :: %__MODULE__{}

  schema "game_boards" do
    field :start_time, :utc_datetime_usec
    field :end_time, :utc_datetime_usec
    belongs_to :user, User, foreign_key: :uid, references: :uid, type: :string
    field :score, :integer
    field :dropped_bricks, :integer
    field :correctly_answered_qna, :integer
  end

  def changeset(board, attrs \\ %{}) do
    board
    |> cast(attrs, [
      :start_time,
      :end_time,
      :uid,
      :score,
      :dropped_bricks,
      :correctly_answered_qna
    ])
  end

  def game_record_query(order_by \\ "score") do
    from r in __MODULE__,
      order_by: [desc: ^(order_by |> String.to_atom())],
      order_by: [asc: r.end_time - r.start_time],
      limit: 10,
      preload: [:user]
  end

  def preloads(query, preloads) when is_list(preloads) do
    from q in query, preload: ^preloads
  end

  def by_time(start_time) do
    from r in __MODULE__,
      where: r.start_time >= ^start_time,
      order_by: [desc: r.score]
  end

  def by_start_and_end_time(start_time, end_time) do
    from r in __MODULE__,
      where:
        r.start_time >= ^start_time and
          r.end_time <= ^end_time,
      order_by: [desc: r.score]
  end
end
