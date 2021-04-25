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
    facebook: {Ueberauth.Strategy.Facebook, []}
  ]

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
      client_id: System.get_env("FACEBOOK_CLIENT_ID"),
      client_secret: System.get_env("FACEBOOK_CLIENT_SECRET")  
      
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email", allow_private_emails: true]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "",
  client_secret: ""

config :quadquizaminos,
  # add github_id of authorized users
  github_ids: [1, 2],

  # set bottom vulnerability defaulting value
  bottom_vulnerability_value: 77,
  # this threshold determines the marking of vulnerability to new incoming block when 
  # brick counter is evenly divided by it
  vulnerability_new_brick_threshold: 7

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
