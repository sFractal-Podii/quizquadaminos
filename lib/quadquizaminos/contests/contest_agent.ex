defmodule Quadquizaminos.Contest.ContestAgent do
  alias Quadquizaminos.Contests
  use Agent

  def start_link(contest_name) do
    Agent.start_link(fn -> contest_name end, name: String.to_atom(contest_name))
  end

  def get_contest(pid) do
    Agent.get(pid, & &1)
  end

  def update_state(pid) do
    Agent.update(pid, &%{contest_name: &1, state: "started"})
  end
end
