defmodule QuadBlockQuizWeb.Router do
  use QuadBlockQuizWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug QuadBlockQuizWeb.Auth
    plug :put_root_layout, {QuadBlockQuizWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :privacy_and_term_of_service do
    plug :put_root_layout, {QuadBlockQuizWeb.LayoutView, "privacy_and_term_of_service.html"}
  end

  pipeline :tailwind_layout do
    plug :put_root_layout, {QuadBlockQuizWeb.LayoutView, "tailwind.html"}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authorize do
    plug QuadBlockQuizWeb.Authorize
  end

  pipeline :authorize_admin do
    plug QuadBlockQuizWeb.Authorize, roles: ["admin"]
  end

  pipeline :authorize_by_login_level do
    plug QuadBlockQuizWeb.Authorize, :login_level
  end

  scope "/", QuadBlockQuizWeb do
    pipe_through [:browser]

    get "/", PageController, :index
    get "/sbom", PageController, :redirect_to_well_known
    get "/.well-known/sbom", PageController, :sbom

    live "/leaderboard/:board_id", LeaderboardLive.Show
    live "/contestboard", ContestboardLive

    live "/contests/:id", ContestsLive, :show
    get "/anonymous", SessionController, :anonymous
    post "/anonymous", SessionController, :anonymous
    resources "/sessions", SessionController, only: [:new, :create]

    pipe_through :authorize
    live "/tetris", TetrisLive, :tetris
    live "/tetris/instructions", TetrisLive, :instructions
    live "/courses/:course", CourseLive, :show
    live "/courses/:course/:chapter", CourseLive, :questions
  end

  scope "/", QuadBlockQuizWeb do
    pipe_through [:browser, :privacy_and_term_of_service]

    live "/termsofservice", TermsOfServiceLive
    live "/privacy", PrivacyLive
  end

  scope "/", QuadBlockQuizWeb do
    pipe_through [:browser, :tailwind_layout]

    get "/how-to-play", PageController, :how_to_play
    live "/contest_rules", ContestRules
    live "/leaderboard", LeaderboardLive
    live "/contests", ContestsLive, :index
    live "/contest-prizes", ContestPrizes

    pipe_through :authorize
    live "/courses", CourseLive
  end

  scope "/admin", QuadBlockQuizWeb, as: :admin do
    pipe_through [:browser, :authorize_admin]

    live "/", AdminLive
    live "/contests", ContestsLive, :index
  end

  scope "/auth", QuadBlockQuizWeb do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", QuadBlockQuizWeb do
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

      live_dashboard "/dashboard", metrics: QuadBlockQuizWeb.Telemetry
    end
  end
end