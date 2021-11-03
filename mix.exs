defmodule Quadquizaminos.MixProject do
  use Mix.Project

  def project do
    [
      app: :quadquizaminos,
      version: "0.11.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext, :unused] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      build_embedded: true,
      deps: deps(),
      unused: [
        ignore: [
          {QuadquizaminosWeb.Router.Helpers},
          {QuadquizaminosWeb.Endpoint},
          {QuadquizaminosWeb.ErrorView},
          {QuadquizaminosWeb.Gettext},
          {Quadquizaminos.ReleaseTask},
          {Quadquizaminos.Repo},
          {QuadquizaminosWeb.Router},
          {QuadquizaminosWeb.SessionView},
          {QuadquizaminosWeb.LayoutView},
          {QuadquizaminosWeb.SessionController},
          {QuadquizaminosWeb.PageController},
          {QuadquizaminosWeb.AuthController},
          {QuadquizaminosWeb.Telemetry},
          {QuadquizaminosWeb.UserSocket},
          {QuadquizaminosWeb.AuthView},
          {QuadquizaminosWeb.PageView},
          {:_, :__schema__, :_},
          {:_, :__struct__, :_},
          {:_, :__changeset__, :_},
          {:_, :child_spec, :_},
          {:_, :__live__, 0}
        ]
      ],
      releases: [
        quadquizaminos: [
          steps: [:assemble, &copy_qna/1]
        ]
      ]
    ]
  end

  defp copy_qna(release) do
    IO.puts("Copying qna folder.....")
    File.cp_r!("qna", release.path <> "/qna")
    File.cp_r!("courses", release.path <> "/courses")
    release
  end

  def application do
    [
      mod: {Quadquizaminos.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :ueberauth_github,
        :ueberauth_google,
        :ueberauth_linkedin,
        :ueberauth,
        :mix
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib", "qna"]

  defp deps do
    [
      {:phoenix, "~> 1.5.7"},
      {:mix_unused, "~> 0.2.0"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.5"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_live_view, "~> 0.15.0"},
      {:floki, ">= 0.27.0", only: :test},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:oauth2, "~> 2.0", override: true},
      {:ueberauth, "~> 0.6"},
      {:ueberauth_github, "~> 0.7"},
      {:ueberauth_linkedin, git: "https://github.com/fajarmf/ueberauth_linkedin"},
      {:ueberauth_google, "~>0.10"},
      {:sbom, git: "https://github.com/voltone/sbom", runtime: false},
      {:earmark, "~> 1.4"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:site_encrypt, "~> 0.4"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
