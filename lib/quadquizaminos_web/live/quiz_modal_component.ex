defmodule QuadquizaminosWeb.QuizModalComponent do
  use QuadquizaminosWeb, :live_component

  def render(assigns) do
    ~L"""
    <button phx-click="play">Continue</button>
    """
  end
end
