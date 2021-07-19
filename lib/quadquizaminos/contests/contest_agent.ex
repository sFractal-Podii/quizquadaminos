defmodule Quadquizaminos.Contest.ContestAgent do
  @moduledoc """
  Each contest spins up a new agent which contains the following information about the contest
    - time elapsed
    - status of the contest
  The agent can have the following statuses
   - running
   - paused

  The agent is responsible for receiving events that will start or stop it.
  The Genserver looksup different processes and monitors them.
  The time elapse of each contest is updated depending on different state.
  The agent is stopped to end the process.
  """

  alias Quadquizaminos.Contests
  use Agent

  def start_link(opts) do
    state = %{contest_name: opts[:name], time_elapsed: 0, status: :running}
    {:ok, pid} = Agent.start_link(fn -> state end, opts)

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

  def update_timer(name) do
    name
    |> Agent.get_and_update(fn
      %{time_elapsed: time, status: :running} = state ->
        {state, %{state | time_elapsed: time + 1}}

      state ->
        {state, state}
    end)
  end

  def pause_contest(name) do
    name
    |> String.to_atom()
    |> Agent.update(fn state -> %{state | status: :paused} end)
  end

  def resume_contest(name) do
    name
    |> String.to_atom()
    |> Agent.update(fn state -> %{state | status: :running} end)
  end

  def end_contest(name) do
    name
    |> String.to_atom()
    |> Agent.stop()
  end
end
