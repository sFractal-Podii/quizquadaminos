defmodule Quadquizaminos.Contests do
  alias Quadquizaminos.Contest
  alias Quadquizaminos.Repo

  alias Quadquizaminos.Contest.ContestAgent

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

  def start_contest(name) do
    Repo.transaction(fn ->
      ContestAgent.start_link(name)

      name
      |> get_contest()
      |> update_contest(%{start_time: DateTime.utc_now()})
    end)

    # start the agent
    # update start time
  end

  def end_contest(id) do
    # update end_time
    # stop the agent
  end

  def update_contest(contest, attrs) do
    contest
    |> Contest.changeset(attrs)
    |> Repo.update()
  end
end

# display timer
# initial contest_counter -> 0
