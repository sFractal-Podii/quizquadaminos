defmodule Quadquizaminos.Questions.Question do
  # @enforce_keys [:type, :question]
  @type t :: %__MODULE__{
          type: atom(),
          question: String.t(),
          correct: String.t(),
          title: String.t(),
          score: map(),
          description: String.t(),
          powerup: atom(),
          choices: list()
        }
  defstruct title: nil,
            type: nil,
            correct: nil,
            question: nil,
            description: nil,
            choices: [],
            score: %{right: 0, wrong: 0},
            powerup: nil
end
