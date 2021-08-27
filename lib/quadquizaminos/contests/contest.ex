defmodule Quadquizaminos.Contests.Contest do
  @moduledoc """
  Schema for contest

  ### status
  Shows the current status of the contest, it can be any of the following:
  - running : the contest is currently active
  - stopped : the contest was has been stopped
  - future : the contest will happen in the future
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @sort_order [:running, :future, :stopped]

  schema "contests" do
    field :start_time, :utc_datetime_usec
    field :end_time, :utc_datetime_usec
    field :time_elapsed, :integer, virtual: true, default: 0
    field :status, :string, virtual: true
    field :add_contest_date, :boolean, virtual: true, default: false
    field :edit_contest_date, :boolean, virtual: true, default: false
    field :time_remaining, :integer, virtual: true, default: 0
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

  def compare({s1, _}, {s2, _}) do
    s1_index = Enum.find_index(@sort_order, fn s -> s == s1 end)
    s2_index = Enum.find_index(@sort_order, fn s -> s == s2 end)

    cond do
      s1_index > s2_index -> :gt
      s1_index < s2_index -> :lt
      true -> :eq
    end
  end
end
