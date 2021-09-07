defmodule Quadquizaminos.Contests do
  alias Quadquizaminos.Contests.Contest
  alias Quadquizaminos.Accounts.User

  alias Quadquizaminos.GameBoard
  alias Quadquizaminos.Repo
  alias Quadquizaminos.Contests.RSVP

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

  @doc """
  Populates relevant the contest virtual fields
  """
  @spec load_contest_vitual_fields(Contest.t() | [Contest.t()]) :: Contest.t()
  def load_contest_vitual_fields(%Contest{} = contest) do
    status =
      case contest_status(contest.name) do
        :stopped ->
          if future_contest?(contest) do
            :future
          else
            :stopped
          end

        status ->
          status
      end

    %{contest | status: status, time_elapsed: time_elapsed(contest.name)}
  end

  def load_contest_vitual_fields(contests) when is_list(contests) do
    Enum.map(contests, &load_contest_vitual_fields/1)
  end

  def load_contest_vitual_fields(%Contest{} = contest, %User{} = user) do
    %{contest | rsvped?: user_rsvped?(user, contest)}
    |> load_contest_vitual_fields()
  end

  def load_contest_vitual_fields(contests, %User{} = user) when is_list(contests) do
    Enum.map(contests, fn contest -> load_contest_vitual_fields(contest, user) end)
  end

  @doc """
  Returns a boolean indicating whether the contest will occur in the future.
  If its exact match then false if returned
  """
  @spec future_contest?(Contest.t()) :: boolean()
  def future_contest?(name) when is_binary(name) do
    Repo.get_by(Contest, name: name)
    |> future_contest?()
  end

  def future_contest?(%Contest{contest_date: nil}), do: true

  def future_contest?(%Contest{contest_date: date}) do
    case DateTime.compare(date, DateTime.utc_now()) do
      :gt -> true
      _ -> false
    end
  end

  @doc """
  gets all the contests in the database, by default sorts them by the contest date in descending order
  """
  def list_contests do
    q = from c in Contest, order_by: [desc: c.contest_date]
    Repo.all(q)
  end

  @doc """
  Get ids of all the current contests
  """

  def list_contest_ids do
    q = from c in Contest, order_by: [desc: c.contest_date], select: c.id
    Repo.all(q)
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
  checks if the active contest has no contest date set
  """
  @spec active_contest_without_date?(integer()) :: boolean()
  def active_contest_without_date?(contest_id) do
    contest_id
    |> Contest.by_id()
    |> Contest.active_contest_without_date()
    |> Repo.exists?()
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
    case ContestAgent.contest_status(name) do
      :stopped ->
        if future_contest?(name) do
          :future
        else
          :stopped
        end

      status ->
        status
    end
  end

  def time_elapsed(%Contest{name: name}), do: time_elapsed(name)

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

  @doc """
  creates a new RSVP on the database
  """
  @spec create_rsvp(map(), User.t()) :: {:ok, RSVP.t()} | {:error, Changeset.t()}
  def create_rsvp(attrs, %User{} = current_user) do
    %RSVP{} |> RSVP.changeset(attrs, current_user) |> Repo.insert()
  end

  @doc """
  Creates an RSVP changeset
  """
  @spec change_rsvp(RSVP.t(), map()) :: Ecto.Changeset.t()
  def change_rsvp(rsvp \\ %RSVP{}, attrs \\ %{}) do
    RSVP.changeset(rsvp, attrs, %User{})
  end

  @doc """
  deletes RSVP from the database
  """
  @spec cancel_rsvp(integer(), User.t()) :: {:ok, RSVP.t()} | {:error, Changeset.t()}
  def cancel_rsvp(contest_id, %User{} = user) do
    user
    |> RSVP.user_contest_rsvp_query(contest_id)
    |> Repo.one()
    |> Repo.delete()
  end

  def user_rsvped?(%User{uid: nil}, %Contest{}), do: false

  def user_rsvped?(%User{} = user, %Contest{} = contest) do
    user
    |> RSVP.user_contest_rsvp_query(contest)
    |> Repo.exists?()
  end
end
