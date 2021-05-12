defmodule QuadquizaminosWeb.InstructionsComponent do
  use QuadquizaminosWeb, :live_component
  import QuadquizaminosWeb.Instructions

  def render(assigns) do
    ~L"""
     <div>
     <div class="float-right">
      <a phx-click="close_instructions">&times;</a>
     </div>
     <br>
     <%= raw game_instruction() %>
     </div>
    """
  end
end
