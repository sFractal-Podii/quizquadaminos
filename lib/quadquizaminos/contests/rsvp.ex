defmodule Quadquizaminos.Contests.RSVP do
  @moduledoc """
  Schema for reservations on the contests by users
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  @type t :: %__MODULE__{}

  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.Contests.Contest

  schema "rsvps" do
    belongs_to :user, User, references: :uid, type: :string
    belongs_to :contest, Contest
    timestamps()
  end

  def changeset(rsvp, attrs, current_user) do
    rsvp
    |> cast(attrs, [:contest_id])
    |> add_user(current_user)
  end

  defp add_user(changeset, %User{uid: uid}) do
    if changeset.valid? do
      put_change(changeset, :user_id, uid)
    else
      changeset
    end
  end

  def user_contest_rsvp_query(%User{uid: uid}, %Contest{id: cid}) do
    from r in "rsvps", where: r.user_id == ^uid and r.contest_id == ^cid, select: r
  end
end