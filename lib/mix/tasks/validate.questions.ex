defmodule Mix.Tasks.Validate.Questions do
  use Mix.Task

  @shortdoc "Checks that question format on markdown file is valid"
  @impl Mix.Task
  def run(_) do
    require Logger
    Logger.info("Validating questions....")
    Quadblockquiz.QnA.validate_files()
    Logger.info("All Files are valid!")
  end
end
