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

    <%= show_powers(assigns) %>
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
     <%=  display(power) %>
     <% end %>
    """
  end

  def display(power) do
    case power do
      {power, power_tick} ->
        ~E"""
        <i class="fas <%=power_icon(power)%>" phx-click="powerup" phx-value-powerup="<%= power %>" phx-value-power_tick="<%= power_tick %>"></i> 

        """

      power ->
        ~E"""
        <i class="fas <%=power_icon(power)%>" phx-click="powerup" phx-value-powerup="<%= power %>"></i> 
        """
    end
  end

  defp power_icon(power) do
    case power do
      :fewervulnerability -> "fa-clipboard-check"
      :deleteblock -> "fa-minus-square"
      :addblock -> "fa-plus-square"
      :moveblock -> "fa-arrows-alt"
      :clearblocks -> "fa-eraser"
      :nextblock -> "fa-crosshairs"
      :speedup -> "fa-fast-forward"
      :slowdown -> "fa-fast-backward"
      :forensics -> "fa-microscope"
      :slowvulns -> "fa-clipboard-check"
      :slowlicense -> "fa-certificate"
      :legal -> "fa-gavel"
      :cyberinsurance -> "fa-file-contract"
      :sbom -> "fa-id-card"
      :fixvuln -> "fa-wrench"
      :fixlicense -> "fa-screwdriver"
      :fixallvulns -> "fa-hammer"
      :fixalllicenses -> "fa-tape"
      :automation -> "fa-toolbox"
      :openchain -> "fa-tools"
      :stopattack -> "fa-file-prescription"
      :winlawsuit -> "fa-balance-scale"
      :superpower -> "fa-superpowers"
    end
  end
end
