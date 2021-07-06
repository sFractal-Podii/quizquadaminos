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

# Google authentication configuration
config :ueberauth, Ueberauth,
  providers: [
    google:
      {Ueberauth.Strategy.Google, [default_scope: "email profile", allow_private_emails: true]}
  ]

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: "34361115589-0qbjmuh1orf3a59ushvvpahj2a7e3nqu.apps.googleusercontent.com",
  client_secret: "9reIErXRW4a0sMvfkxi8yhWM"

# Linkedin authentication configuration 
config :ueberauth, Ueberauth,
  providers: [
    linkedin: {Ueberauth.Strategy.LinkedIn, [default_scope: "r_liteprofile r_emailaddress"]}
  ]

config :ueberauth, Ueberauth.Strategy.LinkedIn.OAuth,
  client_id: "77oypqbpa236ch",
  client_secret: "uj3PCnO7U9RGYadT"

# Facebook Uberauth configuration
config :ueberauth, Ueberauth,
  providers: [
    facebook: {Ueberauth.Strategy.Facebook, []}
  ]
#facebook (provider) configuration 
config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: "",
  client_secret: ""

# Github authentication configuration 
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email", allow_private_emails: true]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "4a4208b91287caaa3c9f",
  client_secret: "f9a66591504ae801955cb2282204fc5f4c0d9621"

config :quadquizaminos,
  # add github_id of authorized users
  github_ids: [32_665_021],
  conference_date: ~U[2021-05-18 18:40:00Z],

  # set bottom vulnerability defaulting value
  bottom_vulnerability_value: 77,
  # this threshold determines the marking of vulnerability to new incoming block when 
  # brick counter is evenly divided by it
  vulnerability_new_brick_threshold: 7

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
