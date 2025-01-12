defmodule Quadblockquiz.MixProject do
  use Mix.Project

  def project do
    [
      app: :quadblockquiz,
      description: "Descri'be",
      version: "1.1.13",
      elixir: "~> 1.15.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      build_embedded: true,
      deps: deps(),
      releases: [
        quadblockquiz: [
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

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Quadblockquiz.Application, []},
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

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib", "qna"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.17"},
      {:phoenix_ecto, "~> 4.5.1"},
      {:ecto_sql, "~> 3.11.1"},
      {:postgrex, ">= 0.19.3"},
      {:phoenix_live_view, "~> 0.20.14"},
      {:floki, ">= 0.37.0", only: :test},
      {:phoenix_html, "~> 4.1.1"},
      {:phoenix_html_helpers, "~> 1.0"},
      {:phoenix_view, "~> 2.0"},
      {:phoenix_live_reload, "~> 1.5.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.8.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.22.3"},
      {:jason, "~> 1.4.1"},
      {:plug_cowboy, "~> 2.7"},
      {:oauth2, "2.0.1", override: true},
      {:ueberauth, "~>0.6"},
      {:ueberauth_github, "~>0.7"},
      {:ueberauth_linkedin, git: "https://github.com/fajarmf/ueberauth_linkedin"},
      {:ueberauth_google, "~>0.10"},
      {:sbom,
       git: "https://github.com/sigu/sbom.git",
       only: :dev,
       branch: "auto-install-bom",
       runtime: false},
      {:earmark, "~> 1.4.47"},
      {:credo, "~> 1.7.10", only: [:dev, :test], runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": [
        "cmd --cd assets node build.js",
        "cmd --cd assets npm run deploy",
        "phx.digest"
      ],
      sbom: ["sbom.install", "sbom.cyclonedx", "sbom.phx"]
    ]
  end
end
