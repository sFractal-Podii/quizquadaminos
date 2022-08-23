defmodule Quadblockquiz.GameBoard do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Quadblockquiz.Accounts.User

  @type t :: %__MODULE__{}

  schema "game_boards" do
    field :start_time, :utc_datetime_usec
    field :end_time, :utc_datetime_usec
    belongs_to :user, User, foreign_key: :uid, references: :uid, type: :string
    field :score, :integer
    field :dropped_bricks, :integer
    field :bottom_blocks, :map
    field :correctly_answered_qna, :integer
    field :powerups, :string
    belongs_to :contest, Quadblockquiz.Contests.Contest
  end

  def changeset(board, attrs \\ %{}) do
    board
    |> cast(attrs, [
      :start_time,
      :contest_id,
      :end_time,
      :uid,
      :score,
      :bottom_blocks,
      :dropped_bricks,
      :powerups,
      :correctly_answered_qna
    ])
  end

  def game_record_query(order_by \\ "score") do
    from r in __MODULE__,
      order_by: [desc: ^(order_by |> String.to_atom())],
      order_by: [asc: r.end_time - r.start_time],
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

  def by_contest(query, contest_id) do
    from q in query,
      where: q.contest_id == ^contest_id
  end

  def sort_by(query, sorter \\ "score") do
    from r in query,
      order_by: [desc: ^(sorter |> String.to_atom())],
      order_by: [asc: r.end_time - r.start_time]
  end

  def by_start_and_end_time(start_time, nil) do
    from r in __MODULE__,
      where: r.start_time >= ^start_time
  end

  def by_start_and_end_time(start_time, end_time) do
    from r in __MODULE__,
      where:
        r.start_time >= ^start_time and
          r.end_time <= ^end_time

    # order_by: [desc: r.score]
  end

  def paginate_query(query, page, per_page) do
    from q in query,
      offset: (^page - 1) * ^per_page,
      limit: ^per_page
  end
end
