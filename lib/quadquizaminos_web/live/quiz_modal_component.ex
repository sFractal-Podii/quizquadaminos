defmodule QuadquizaminosWeb.QuizModalComponent do
  use QuadquizaminosWeb, :live_component
  alias Quadquizaminos.QnA

  def render(%{category: nil} = assigns) do
    ~L"""
    <div>

    <button phx-click="unpause">Continue</button>
    <%= for category <- QnA.categories() do %>
     <button phx-click="choose_category" phx-value-category="<%= category%>"><%= Macro.camelize(category) %></button>
    <% end %>
    </div>
    """
  end

  def render(assigns) do
    ~L"""
    <div>
         <h2><%= raw @qna.question %></h2>
         <h2> Answer </h2>
        <%= f =  form_for :quiz, "#", phx_submit: :check_answer %>
        <%= for {answer, index}<- @qna.answers do %>
        <%= label do %>
          <%= radio_button f, :guess, answer, value: index %>
          <%= answer %>
         <% end %> <!-- end label -->
        <% end %>
       <%= submit  "Continue" %>
       </form>
        <div>
    """
  end
end
