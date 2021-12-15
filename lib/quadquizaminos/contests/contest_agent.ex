defmodule Quadquizaminos.Contest.ContestAgent do
  @moduledoc """
  Each contest spins up a dynamically supervised agent which contains the following information about the contest
    - time elapsed
    - status of the contest
    - contest name
  The agent can have the following statuses
   - running
   - paused
   - stopped
    The agent is responsible for receiving events that will start, reset or stop it
  """

  use Agent

  def start_link(opts) do
    state = %{contest_name: opts[:name], time_elapsed: 0, status: :running}
    {:ok, _pid} = Agent.start_link(fn -> state end, opts)
    :ets.new(opts[:name], [:named_table, :public])
    :timer.apply_interval(1000, __MODULE__, :update_timer, [opts[:name]])
    state
  end

  def time_elapsed(name) do
    if GenServer.whereis(name |> String.to_atom()) do
      name |> String.to_atom() |> Agent.get(fn state -> state.time_elapsed end)
    else
      0
    end
  end

  def contest_status(name) do
    name = String.to_atom(name)

    if GenServer.whereis(name) do
      name |> Agent.get(fn state -> state.status end)
    else
      :stopped
    end
  end

  def reset_timer(name) do
    name
    |> String.to_atom()
    |> Agent.update(fn state -> %{state | time_elapsed: 0} end)
  end

  def resume_contest(name) do
    name
    |> String.to_atom()
    |> Agent.update(fn state -> %{state | status: :running} end)
  end

  def end_contest(name) do
    name = String.to_atom(name)

    if :ets.whereis(name) != :undefined do
      :ets.delete(name)
    end

    Agent.stop(name)
  end
end
