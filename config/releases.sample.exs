import Config

host_url = "35.232.208.120"

# Configure your database
config :quadquizaminos, Quadquizaminos.Repo,
  username: "postgres",
  password: "provide_database_password",
  database: "quadquizaminos_prod",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :quadquizaminos, QuadquizaminosWeb.Endpoint,
  http: [:inet6, port: 4000],
  secret_key_base: "add_secret_key_base"

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email", allow_private_emails: true]}
  ]

# provide client_id and secret_id generated after creating Oauth app
config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "",
  client_secret: ""

config :quadquizaminos,
  # add github_id of authorized users
  github_ids: []

config :quadquizaminos, QuadquizaminosWeb.Endpoint, url: [host: host_url, port: 4000]
