defmodule Quadquizaminos.Contest.ContestAgent do
  alias Quadquizaminos.Contests
  use Agent

  def start_link(contest_name) do
    {:ok, pid} = Agent.start_link(fn -> contest_name end, name: String.to_atom(contest_name))
    broadcast_state(pid)                  
  end

  def broadcast_state(pid) do
    Agent.cast(pid, &broadcast!(%{contest_name: &1, running: true}))
  end

  defp broadcast!(message) do
    QuadquizaminosWeb.Endpoint.broadcast!(
      "timer",
      "timer",
      message
    )
  end
end
