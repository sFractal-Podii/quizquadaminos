import Config

# host_url is the static IP address provided once VM instance has been launched.
# Replace this with the one provided.
host_url = "35.232.208.120"

# Configure your database
# In order to configure the database, you must create a database instance on GCP.
# Provide the username, password, database name and hostname(public IP address)
config :quadquizaminos, Quadquizaminos.Repo,
  username: "postgres",
  password: "provide_database_password",
  database: "database_name",
  hostname: "host_name",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# use `mix phx.gen.secret` to generate the secret key base.
# run the command on your terminal under the quizquadaminos directory:

# quizquadaminos$ mix phx.gen.secret
#    "Thi679jhjhjasfrkf1q23dddd0......................"

#  secret_key_base: "Thi679jhjhjasfrkf1q23dddd0......................"

config :quadquizaminos, QuadquizaminosWeb.Endpoint,
  http: [:inet6, port: 4000],
  secret_key_base: "add_secret_key_base"

# ueberauth configuration.
# For more information visit https://github.com/ueberauth/ueberauth_github
config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email", allow_private_emails: true]}
  ]

# provide client_id and client_secrets generated after creating an OAuth app on github
# Guide on how to create an OAuth app has been added to ./README.md(Set up Github OAuth app)
config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "",
  client_secret: ""

# Provide github ids for users who will be allowed to play this game
# github_ids: [1111, 2222]
config :quadquizaminos,
  github_ids: []

config :quadquizaminos, QuadquizaminosWeb.Endpoint, url: [host: host_url, port: 4000]
