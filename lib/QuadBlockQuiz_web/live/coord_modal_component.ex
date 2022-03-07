defmodule QuadBlockQuizWeb.CoordModalComponent do
  use QuadBlockQuizWeb, :live_component

  def render(assigns) do
    ~L"""
      <%=if :addblock in @powers do %>
      <%= f =  form_for :coord, "#", phx_submit: :add_block %>
       <label>x-coord </label>
       <%= text_input f, :x, type: :number, min: "1", max: "10" %>
       <label>y-coord </label>
       <%= text_input f, :y, type: :number, min: "1", max: "20" %>
      <%= submit  "Add Block" %>
      </form>
      <% end %>      
    """
  end
end
