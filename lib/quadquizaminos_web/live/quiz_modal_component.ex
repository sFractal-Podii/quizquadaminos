defmodule QuadquizaminosWeb.QuizModalComponent do
  use QuadquizaminosWeb, :live_component

  def render(assigns) do
    ~L"""
    <div>

    <button phx-click="unpause">Continue</button>
    <%= for category <- categories() do %>
     <button phx-click="choose_category" phx-value-category="<%= category%>"><%= category %></button>
    <% end %>
    </div>
    """
  end

  defp categories do
    "qna"
    |> File.ls!()
    |> Enum.filter(fn folder -> File.dir?("./qna/#{folder}") end)
    |> Enum.map(fn folder -> Macro.camelize(folder) end)
  end
end
