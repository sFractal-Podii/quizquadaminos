defmodule Quadquizaminos.ReleaseTask do
  @moduledoc """
  Tasks that can be automatically run during release
  """
  @app :quadquizaminos

  def migrate do
    load_app()

    IO.puts("Running migrations for Quadquizaminos.Repo")

    {:ok, _, _} =
      Ecto.Migrator.with_repo(Quadquizaminos.Repo, &Ecto.Migrator.run(&1, :up, all: true))
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  defp load_app do
    Application.load(@app)
  end
end
