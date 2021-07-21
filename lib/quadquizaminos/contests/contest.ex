defmodule Quadquizaminos.Contest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "contests" do
    field :start_time, :utc_datetime_usec
    field :end_time, :utc_datetime_usec
    field :time_elapsed, :integer, virtual: true, default: 0
    field :status, :string, virtual: true
    field :name, :string
    has_many :game_records, Quadquizaminos.GameBoard
  end

  def changeset(contest, attrs \\ %{}) do
    contest
    |> cast(attrs, [
      :start_time,
      :end_time,
      :name
    ])
    |> validate_required([:name])
    |> validate_length(:name, min: 3)
  end
end
