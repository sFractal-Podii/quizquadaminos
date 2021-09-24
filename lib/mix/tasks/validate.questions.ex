defmodule Mix.Tasks.Validate.Questions do
  use Mix.Task

  @directories "courses"

  @shortdoc "Checks that question format on markdown file is valid"
  @impl Mix.Task
  def run(_) do
    require Logger
    Logger.info("Validating questions....")
    Quadquizaminos.QnA.validate_files()
    Logger.info("All Files are valid!")
  end

  @doc """
    Lists all the fill path in the course directory
  """
  def all_files do
    names = File.ls!(@directories)

    path =
      for dir <- names do
        files("#{@directories}/#{dir}")
      end

    paths = List.flatten(path)
    paths
  end

  defp files(dir) do
    if File.dir?(dir) do
      dir
      |> File.ls!()
      |> Enum.map(fn x ->
        path = dir <> "/" <> x

        if File.dir?(path) do
          files(path)
        else
          path
        end
      end)
    else
      "course" <> "/" <> dir
    end
  end
end
