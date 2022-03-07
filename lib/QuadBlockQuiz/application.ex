defmodule QuadBlockQuiz.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: QuadBlockQuiz.ContestAgentSupervisor},

      # Start the Ecto repository
      QuadBlockQuiz.Repo,
      # Start the Telemetry supervisor
      QuadBlockQuizWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: QuadBlockQuiz.PubSub},
      # Start the Endpoint (http/https)
      QuadBlockQuizWeb.Endpoint
      # Start a worker by calling: QuadBlockQuiz.Worker.start_link(arg)
      # {QuadBlockQuiz.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: QuadBlockQuiz.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    QuadBlockQuizWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
