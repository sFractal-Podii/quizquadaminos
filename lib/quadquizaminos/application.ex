defmodule Quadquizaminos.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Quadquizaminos.ContestAgentSupervisor},

      Quadquizaminos.Repo,
      QuadquizaminosWeb.Telemetry,
      {Phoenix.PubSub, name: Quadquizaminos.PubSub},
      {SiteEncrypt.Phoenix, QuadquizaminosWeb.Endpoint}
    ]

    opts = [strategy: :one_for_one, name: Quadquizaminos.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    QuadquizaminosWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
