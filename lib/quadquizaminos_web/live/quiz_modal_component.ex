defmodule QuadquizaminosWeb.QuizModalComponent do
  use QuadquizaminosWeb, :live_component
  alias Quadquizaminos.QnA

  def render(%{category: nil} = assigns) do
    ~L"""
    <div style="text-align:center;">

    <button phx-click="unpause">Continue</button><br>
    <%= for category <- QnA.categories() do %>
     <button phx-click="choose_category" phx-value-category="<%= category%>"><%= Macro.camelize(category) %></button>
    <% end %>
    <br>

    <%= show_powers(assigns) %><br>
    <button phx-click="endgame">End Game</button><br>
    </div>
    """
  end

  def render(assigns) do
    ~L"""
    <div>
         <div class ="float-right"><h2><b>Total Score:</b><%= @score %></h2></div>
         <br/>
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
       <br/>
       <%= unless Enum.empty?(@qna.score) do %>
       <h2>Scores</h2>
       <ul>
         <li>Right answer:<b>+<%= @qna.score["Right"] %></b></li>
         <li>Wrong answer:<b>-<%= @qna.score["Wrong"] %></b></li>
       </ul>
       <% end %>
    <div>
    """
  end

  defp show_powers(assigns) do
    ~L"""
     <%= for power <- @powers do %>
     <i class="<%= prefix(power)%> <%=power_icon(power)%>" title="<%= power |> to_string() %>" phx-click="powerup" phx-value-powerup="<%= power %>"></i>
     <% end %>
    """
  end

  defp power_icon(power) do
    case power do
      :deleteblock -> "fa-minus-square"
      :addblock -> "fa-plus-square"
      :moveblock -> "fa-arrows-alt"
      :clearblocks -> "fa-eraser"
      :speedup -> "fa-fast-forward"
      :slowdown -> "fa-fast-backward"
      :fixvuln -> "fa-wrench"
      :fixlicense -> "fa-screwdriver"
      :rm_all_vulns -> "fa-hammer"
      :rm_all_lic_issues -> "fa-tape"
      :superpower -> "fa-superpowers"
    end
  end

  defp prefix(:superpower), do: "fab"
  defp prefix(power), do: "fas"
end
