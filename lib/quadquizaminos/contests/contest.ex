defmodule Quadquizaminos.Contests.Contest do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "contests" do
    field :start_time, :utc_datetime_usec
    field :end_time, :utc_datetime_usec
    field :time_elapsed, :integer, virtual: true, default: 0
    field :status, :string, virtual: true
    field :add_contest_date, :boolean, virtual: true, default: false
    field :edit_contest_date, :boolean, virtual: true, default: false
    field :name, :string
    field :contest_date, :utc_datetime_usec
    has_many :game_records, Quadquizaminos.GameBoard
  end

  def changeset(contest, attrs \\ %{}) do
    contest
    |> cast(attrs, [
      :start_time,
      :end_time,
      :name,
      :contest_date
    ])
    |> validate_required([:name])
    |> validate_length(:name, min: 3)
  end

  def by_id(id) do
    from c in __MODULE__,
      where: c.id == ^id
  end

  def ended_contest(query) do
    from c in query, where: not is_nil(c.start_time) and not is_nil(c.end_time)
  end
end
