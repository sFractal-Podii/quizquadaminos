defmodule Quadblockquiz.ReleaseTask do
  @moduledoc """
  Tasks that can be automatically run during release
  """
  @app :quadblockquiz
  @start_apps [:postgrex, :ecto, :ecto_sql]
  @repo Quadblockquiz.Repo

  def migrate do
    load_app()

    IO.puts("Running migrations for Quadblockquiz.Repo")

    {:ok, _, _} = Ecto.Migrator.with_repo(@repo, &Ecto.Migrator.run(&1, :up, all: true))
  end

  def createdb do
    # Start postgrex and ecto
    IO.puts("Starting dependencies...")

    # Start apps necessary for executing migrations
    Enum.each(@start_apps, &Application.ensure_all_started/1)
    :ok = ensure_repo_created(@repo)
    IO.puts("createdb task done!")
  end

  defp ensure_repo_created(repo) do
    IO.puts("create #{inspect(repo)} database if it doesn't exist")

    case repo.__adapter__.storage_up(repo.config) do
      :ok -> :ok
      {:error, :already_up} -> :ok
      {:error, term} -> {:error, term}
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp load_app do
    Application.load(@app)
  end
end
