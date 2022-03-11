defmodule Quadblockquiz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Quadblockquiz.ContestAgentSupervisor},

      # Start the Ecto repository
      Quadblockquiz.Repo,
      # Start the Telemetry supervisor
      QuadblockquizWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Quadblockquiz.PubSub},
      # Start the Endpoint (http/https)
      QuadblockquizWeb.Endpoint
      # Start a worker by calling: Quadblockquiz.Worker.start_link(arg)
      # {Quadblockquiz.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Quadblockquiz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    QuadblockquizWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
