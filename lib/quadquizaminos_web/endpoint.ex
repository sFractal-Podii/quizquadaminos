defmodule QuadquizaminosWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :quadquizaminos
  use SiteEncrypt.Phoenix

  @session_options [
    store: :cookie,
    key: "_quadquizaminos_key",
    signing_salt: "LJXBjDvl"
  ]

  socket "/socket", QuadquizaminosWeb.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  plug Plug.Static,
    at: "/",
    from: :quadquizaminos,
    gzip: true,
    only: ~w(css fonts images js favicon.ico robots.txt .well-known)

  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :quadquizaminos
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug QuadquizaminosWeb.Router

  @impl SiteEncrypt
  def certification do
    config = [
      client: :native,
      domains: ["quizquad.podiihq.com"],
      emails: ["podii@podiihq.com"],
      db_folder: System.get_env("SITE_ENCRYPT_DB", Path.join("tmp", "site_encrypt_db")),
      directory_url:
      case System.get_env("CERT_MODE", "local") do
        "local" -> {:internal, port: 4002}
      end
      ]
    SiteEncrypt.configure(config)
  end
  @impl Phoenix.Endpoint
  def init(_key, config) do
    IO.inspect("((((((")
    ha = {:ok, SiteEncrypt.Phoenix.configure_https(config)}
    IO.inspect ha, label: "(((((((())))))))))"
    ha
  end
end
