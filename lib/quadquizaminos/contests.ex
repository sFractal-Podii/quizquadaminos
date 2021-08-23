defmodule Quadquizaminos.Contests do
  alias Quadquizaminos.Contest

  alias Quadquizaminos.GameBoard
  alias Quadquizaminos.Repo

  alias Quadquizaminos.Contest.ContestAgent
  import Ecto.Query, only: [from: 2]

  def create_contest(attrs) do
    %Contest{}
    |> Contest.changeset(attrs)
    |> Repo.insert()
  end

  def get_contest(id) when is_integer(id) do
    Repo.get(Contest, id)
  end

  def get_contest(name) do
    Repo.get_by(Contest, name: name)
  end

  def list_contests do
    Repo.all(Contest)
  end

  @doc """
  Returns all contests that begin in the future
  """
  def future_contests do
    q = from c in Contest, where: c.contest_date > ^DateTime.utc_now()
    Repo.all(q)
  end

  @doc """
  Get all past contests
  """
  def past_contests do
    q = from c in Contest, where: not is_nil(c.end_time)
    Repo.all(q)
  end

  @doc """
  Gives us the names of all contests that are either running or paused
  """
  def active_contests_names do
    q = from c in Contest, where: not is_nil(c.start_time) and is_nil(c.end_time), select: c.name
    Repo.all(q)
  end

  @doc """
  Returns all the active contests
  """

  def active_contests do
    q = from c in Contest, where: not is_nil(c.start_time) and is_nil(c.end_time)
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

  def contest_status(name) do
    ContestAgent.contest_status(name)
  end

  def time_elapsed(name) do
    ContestAgent.time_elapsed(name)
  end

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

  def end_contest(name) do
    # update end_time
    Repo.transaction(fn ->
      ContestAgent.end_contest(name)

      name
      |> get_contest()
      |> update_contest(%{end_time: DateTime.utc_now()})
    end)
  end

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
