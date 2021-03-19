defmodule QuadquizaminosWeb.Instructions do


    def game_instruction() do
    """
    <h2>How to play</h2>
        <ol>
          <li>Up arrow key rotates the blocks</li>
          <li>Left arrow key moves the blocks to the left</li>
          <li>Right arrow key moves the blocks to the right</li>
          <li>Down arrow key moves the blocks down</li>
          <li>Debug until powerups: "r" raises dropping speed</li>
          <li>Debug until powerups: "l" lowers dropping speed</li>
          <li>Debug until powerups: "c" clears bottom blocks</li>
        </ol>
    """
    end

end
