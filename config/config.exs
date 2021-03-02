# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :quadquizaminos,
  ecto_repos: [Quadquizaminos.Repo]

# Configures the endpoint
config :quadquizaminos, QuadquizaminosWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "opws1EmgzMXcvizL4aa4yjIHQ5sn4iLXv/5oW5Q3MEW4KnOOJR3GJjWncVAIB4Go",
  render_errors: [view: QuadquizaminosWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Quadquizaminos.PubSub,
  live_view: [signing_salt: "R60FXxE3"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email", allow_private_emails: true]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "4a4208b91287caaa3c9f",
  client_secret: "f9a66591504ae801955cb2282204fc5f4c0d9621"

config :quadquizaminos,
  # add github_id of authorized users
  github_ids: []

config :quadquizaminos,
  # topics of QnA
  topics: [:supply_chain, :sbom, :open_c2, :open_chain, :phoenix, :sponsors],
  # name and questions in :supply_chain topic
  supply_chain: %{name: "Supply Chain", question_number: 1, total_questions: 3, questions:["001","002","003"] },
  sbom: %{name: "SBOM", question_number: 1, total_questions: 4, questions:["001","002","003", "004"] },
  open_c2: %{name: "OpenC2", question_number: 1, total_questions: 1, questions:["001"] },
  open_chain: %{name: "Open Chain", question_number: 1, total_questions: 1, questions:["001"] },
  phoenix: %{name: "Phoenix", question_number: 1, total_questions: 1, questions:["001"] },
  sponsors: %{name: "Sponsors", question_number: 1, total_questions: 1, questions:["001"] }


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
