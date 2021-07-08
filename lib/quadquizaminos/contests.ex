defmodule Quadquizaminos.Contests do
  alias Quadquizaminos.Contest
  alias Quadquizaminos.Repo

  def create_contest(attrs) do
    %Contest{}
    |> Contest.changeset(attrs)
    |> Repo.insert()
  end

  def get_contest(id) do
  end

  def list_contests do
    Repo.all(Contest)
  end

  def start_contest(name) do
    # start the agent
    # update start time
  end

  def end_contest(id) do
    # update end_time
    # stop the agent
  end
end
