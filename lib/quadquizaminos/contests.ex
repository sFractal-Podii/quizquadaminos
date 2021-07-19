defmodule Quadquizaminos.Contests do


  @moduledoc """
  Inserts and gets data from the database that would be used in different functions.
  -list of all contests
  -timer
  -active contests
  """

  alias Quadquizaminos.Contest
  alias Quadquizaminos.Repo

  alias Quadquizaminos.Contest.ContestAgent
  import Ecto.Query, only: [from: 2]

  @doc """
  Inserts the created contest in the database
  """
  @spec create_contest(map()) :: {:ok, Ecto.Schema.t()}| {:error, Ecto.Changeset.t()}
  def create_contest(attrs) do
    %Contest{}
    |> Contest.changeset(attrs)
    |> Repo.insert()
  end

  def get_contest(name) do
    Repo.get_by(Contest, name: name)
  end

  def list_contests do
    Repo.all(Contest)
  end

  @doc """
  Gives us the names of all contests that are either running or paused
  """
  @spec active_contests_names() :: []
  def active_contests_names do
    q = from c in Contest, where: not is_nil(c.start_time) and is_nil(c.end_time), select: c.name
    Repo.all(q)
  end

  @doc """
  Restarts the timer of the contest
  """
  def reset_contest(name) do
    ContestAgent.reset_timer(name)
  end

  def pause_contest(name) do
    ContestAgent.pause_contest(name)
  end

  def resume_contest(name) do
    ContestAgent.resume_contest(name)
  end

  def contest_status(name) do
    ContestAgent.contest_status(name)
  end

  def time_elapsed(name) do
    ContestAgent.time_elapsed(name)
  end

  @doc """
      Start the given contest name and updates the start time
  """
  @spec start_contest(String.t()) :: {:ok, Ecto.Schema.t()}| {:error, Ecto.Changeset.t()}
  def start_contest(name) do
    Repo.transaction(fn ->
      DynamicSupervisor.start_child(
        Quadquizaminos.ContestAgentSupervisor,
        {Quadquizaminos.Contest.ContestAgent, [name: String.to_atom(name)]}
      )

      name
      |> get_contest()
      |> update_contest(%{start_time: DateTime.utc_now()})
    end)
  end

  @doc """
    Ends the given contest name and updates the end time
  """
  @spec end_contest(String.t()) :: {:ok, Ecto.Schema.t()}| {:error, Ecto.Changeset.t()}
  def end_contest(name) do
    Repo.transaction(fn ->
      ContestAgent.end_contest(name)

      name
      |> get_contest()
      |> update_contest(%{end_time: DateTime.utc_now()})
    end)
  end

  @doc """
  Updates the existing contest with the given attributes
  """
  @spec update_contest(Contest.t(), map()) :: {:ok, Contest.t()}| {:error, Ecto.Changeset.t()}
  def update_contest(contest, attrs) do
    contest
    |> Contest.changeset(attrs)
    |> Repo.update()
  end
end
