defmodule Quadquizaminos.Hints do

  def tldr(:intro) do
    """
      <p>Click "How to Play" for instructions.</p>
      <p>Fill all blocks in a row to clear the row.</p>
      <p>Right/left arrows move quads right/left.</p>
      <p>Up arrow rotates falling quad.</p>
      <p>Down arrow drops falling quad.</p>
      <p>Space bar pops up quiz.</p>
      """
  end

  def tldr(_hint) do
    "Oops!"
  end
end
