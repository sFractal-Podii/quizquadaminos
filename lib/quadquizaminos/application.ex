defmodule Quadquizaminos.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Quadquizaminos.DynamicSupervisor},

      # Start the Ecto repository
      Quadquizaminos.Repo,
      # Start the Telemetry supervisor
      QuadquizaminosWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Quadquizaminos.PubSub},
      # Start the Endpoint (http/https)
      QuadquizaminosWeb.Endpoint
      # Start a worker by calling: Quadquizaminos.Worker.start_link(arg)
      # {Quadquizaminos.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Quadquizaminos.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    QuadquizaminosWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
