defmodule Quadquizaminos.Contest do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "contests" do
    field :start_time, :utc_datetime_usec
    field :end_time, :utc_datetime_usec
  end

  def changeset(contest, attrs \\ %{}) do
    contest
    |> cast(attrs, [
      :start_time,
      :end_time
    ])
  end
end
