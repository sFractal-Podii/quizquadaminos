defmodule QuadquizaminosWeb.InstructionsComponent do
    use QuadquizaminosWeb, :live_component

    def render(assigns) do
        ~L"""
         <div>
         <div class="float-right">
          <a phx-click="close_instructions">x</a>
         </div>
         <br>
         <h2>How to play</h2>
         <ol>
           <li>Up arrow key rotates the blocks</li>
           <li>Left arrow key moves the blocks to the left</li>
           <li>Right arrow key moves the blocks to the right</li>
         </ol>
         </div>
        """
    end
end