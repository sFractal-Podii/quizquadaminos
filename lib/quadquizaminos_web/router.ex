defmodule QuadquizaminosWeb.Router do
  use QuadquizaminosWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug QuadquizaminosWeb.Auth
    plug :put_root_layout, {QuadquizaminosWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :privacy_and_term_of_service do
    plug :put_root_layout, {QuadquizaminosWeb.LayoutView, "privacy_and_term_of_service.html"}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authorize do
    plug QuadquizaminosWeb.Authorize
  end

  pipeline :authorize_admin do
    plug QuadquizaminosWeb.Authorize, roles: ["admin"]
  end

  pipeline :authorize_by_login_level do
    plug QuadquizaminosWeb.Authorize, :login_level
  end

  scope "/", QuadquizaminosWeb do
    pipe_through [:browser]

    get "/", PageController, :index

    live "/leaderboard", LeaderboardLive
    live "/contestboard", ContestboardLive
    live "/contest_rules", ContestRules
    live "/contest_prizes", ContestPrizes
    get "/anonymous", PageController, :anonymous
    post "/anonymous", PageController, :anonymous

    pipe_through :authorize
    live "/tetris", TetrisLive, :tetris
    live "/tetris/instructions", TetrisLive, :instructions
  end

  scope "/", QuadquizaminosWeb do
    pipe_through [:browser, :privacy_and_term_of_service]

    live "/termsofservice", TermsOfServiceLive
    live "/privacy", PrivacyLive
  end

  scope "/admin", QuadquizaminosWeb do
    pipe_through [:browser, :authorize_admin]

    live "/", AdminLive
  end

  scope "/auth", QuadquizaminosWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", QuadquizaminosWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).

  if Mix.env() in [:dev, :test, :prod] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      if Mix.env() in [:prod] do
        pipe_through [:browser, :authorize, :authorize_admin]
      else
        pipe_through [:browser]
      end

      live_dashboard "/dashboard", metrics: QuadquizaminosWeb.Telemetry
    end
  end
end
