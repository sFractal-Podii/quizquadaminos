defmodule QuadquizaminosWeb.CourseModalComponent do
  use QuadquizaminosWeb, :live_component

  alias Quadquizaminos.Courses

  def render(assigns) do
    ~L"""
    <div style="text-align:center;">
    <%= for category <- Courses.category_list(@course, @chapter) do %>
     <button><%= Macro.camelize(category) %></button>
    <% end %>
    <br>
    </div>
    """
  end
end
