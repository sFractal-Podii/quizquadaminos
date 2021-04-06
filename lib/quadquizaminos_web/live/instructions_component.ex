defmodule QuadquizaminosWeb.InstructionsComponent do
    use QuadquizaminosWeb, :live_component
    alias Quadquizaminos.Instructions

    def render(assigns) do
        ~L"""
         <div>
         <div class="float-right">
          <a phx-click="close_instructions">x</a>
         </div>
         <br>
         <%= raw Instructions.game_instruction() %>
         </div>
        """
    end
end
