defmodule QuadquizaminosWeb.QuizModalComponent do
  use QuadquizaminosWeb, :live_component

  def render(assigns) do
    ~L"""
    <div>
     <h2><%= @qna.question %></h2>
    <%= f =  form_for :quiz, "#", phx_submit: :check_answer %>
    <%= for answer <- @qna.answers do %>
    <%= radio_button f,  :guess, answer %>
    <label> <%= answer %></label>
    <% end %>

    <%= submit  "Continue" %>


    </form>
    <button phx-click="unpause">Power Up</button>
    </div>
    """
  end
end
