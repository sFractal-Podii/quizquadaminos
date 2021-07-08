defmodule QuadquizaminosWeb.ContestComponent do
  use QuadquizaminosWeb, :live_component
  alias Quadquizaminos.Util

  # def mount(socket) do
  #   {:ok, assign(socket, contest_counter: 0)}
  # end

  def render(assigns) do
    ~L"""
    <td><%= @contest.name%></td>
                 <td>
                     <button phx-click="start" phx-value-contest='<%= @contest.name %>'>Start</button>
                 </td>
                 <td>
                     <button class="red" phx-click="timer" phx-value-timer="stop">Stop</button>
                 </td>
                 <td>
                     <button phx-click="reset">Reset</button>
                 </td>
                 <td>
                     <% {hours, minutes, seconds} = to_human_time(0) %>
                    <p><%= Util.count_display(hours) %>:<%= Util.count_display(minutes) %>:<%= Util.count_display(seconds) %></p>
                   
                    <%#  <button phx-click="final-score">Final Results</button> %>
                 </td>
                 <td><%= @contest.start_time %></td>
    """
  end

  defp to_human_time(seconds) do
    hours = div(seconds, 3600)
    rem = rem(seconds, 3600)
    minutes = div(rem, 60)
    rem = rem(rem, 60)
    seconds = div(rem, 1)
    {hours, minutes, seconds}
  end
end
