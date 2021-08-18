defmodule Quadquizaminos.Contests do



  @moduledoc """
  Inserts and gets data from the database that would be used in different functions.
  -list of all contests
  -timer
  -active contests
  """

  alias Quadquizaminos.Contest
  alias Quadquizaminos.GameBoard
  alias Quadquizaminos.Repo

  alias Quadquizaminos.Contest.ContestAgent
  import Ecto.Query, only: [from: 2]


  @doc """
    creates a contest with the given params
     ## Example
     iex> create_contest(%{name: "ContestB"})
          {:ok,  %Contest{}}

      iex> create_contest(%{name: "C"})
            {:error,  changeset}
  """
  @spec create_contest(map()) :: {:ok, %Contest{}} | {:error, Ecto.Changeset.t()}

  def create_contest(attrs) do
    %Contest{}
    |> Contest.changeset(attrs)
    |> Repo.insert()
  end


  @doc """
  Gets the given contest by name
  """
  def get_contest(name) do
    Repo.get_by(Contest, name: name)
  end


  def get_contest(id) when is_integer(id) do
    Repo.get(Contest, id)
  end


 @doc """
  Displays all the contests
  ## Example
  iex> list_contests
         ["contestA", "contestB", ...]
  """
  @spec list_contests() :: []
  def list_contests do
    Repo.all(Contest)
  end

  @doc """
  Gives us the names of all contests that are either running or paused
  ## Example
  iex> active_contests_name
         ["contestA", "contestB", ...]
  """
  @spec active_contests_names() :: []
  def active_contests_names do
    q = from c in Contest, where: not is_nil(c.start_time) and is_nil(c.end_time), select: c.name
    Repo.all(q)
  end

  @doc """
  Restarts the game, i.e new start time and timer restarted
  """
  def restart_contest(name) do
    ContestAgent.reset_timer(name)
    name
    |> get_contest()
    |> update_contest(%{start_time: DateTime.utc_now()})
  end

  def pause_contest(name) do
    ContestAgent.pause_contest(name)
  end

  def resume_contest(name) do
    ContestAgent.resume_contest(name)
  end


  @doc """
  Checks on the status of the contest
  """
  def contest_status(name) do
    ContestAgent.contest_status(name)
  end

  @doc """
  Gets the state of time elapsed
  """
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
    # update end_time
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

  @doc """
  Checks if the contest has been completed
  """
  @spec ended_contest?(integer()) :: boolean()
  def ended_contest?(contest_id) do
    contest_id
    |> Contest.by_id()
    |> Contest.ended_contest()
    |> Repo.exists?()
  end

  @doc """
  Fetches the game records of a given contest that took place during the time of the contest
  """

  @spec contest_game_records(%Contest{}) :: [%GameBoard{}, ...]
  def contest_game_records(contest, sorter \\ "score") do
    contest.id
    |> ended_contest?()
    |> contest_game_records(contest, sorter)
  end

  defp contest_game_records(true = _ended_contest, contest, sorter) do
    contest.start_time
    |> GameBoard.by_start_and_end_time(contest.end_time)
    |> GameBoard.by_contest(contest.id)
    |> GameBoard.sort_by(sorter)
    |> GameBoard.preloads([:user])
    |> Repo.all()
  end

  defp contest_game_records(_ended_contest, _contest, _sorter), do: []
end
