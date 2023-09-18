import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :quadblockquiz, Quadblockquiz.Repo,
  username: "postgres",
  password: "postgres",
  database: "quadBlockQuiz_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :quadblockquiz, QuadblockquizWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, backends: []

# Print only warnings and errors during test
config :logger, level: :warning

config :quadblockquiz,
  base_questions_directory: Path.join(Path.dirname(__DIR__), "test/quadblockquiz")

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email", allow_private_emails: true]}
  ]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "4b4208b91287cbbb3c9f",
  client_secret: "f9b66591504ae801955cb2200004fc5f4c0d9621"

config :quadblockquiz,
  # add github_id of authorized users
  github_ids: [4_000_000],
  conference_date: ~U[2021-05-18 18:40:00Z],

  # set bottom vulnerability defaulting value
  bottom_vulnerability_value: 77,
  # this threshold determines the marking of vulnerability to new incoming block when
  # brick counter is evenly divided by it
  vulnerability_new_brick_threshold: 7
