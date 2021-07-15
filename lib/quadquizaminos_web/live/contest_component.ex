defmodule QuadquizaminosWeb.ContestComponent do
  use QuadquizaminosWeb, :live_component
  alias Quadquizaminos.Util

  alias Quadquizaminos.Contests

  def mount(socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <td><%= @contest.name%></td>
                 <td>
                 <%= start_or_pause_button(assigns, @contest.status) %>
                 </td>
                 <td>
                     <button class="red" phx-click="timer" phx-value-timer="stop">Stop</button>
                 </td>
                 <td>
                     <button phx-click="reset">Reset</button>
                 </td>
                 <td>
                  <% {hours, minutes, seconds} = @contest.time_elapsed |> to_human_time() %>
                    <p><%= Util.count_display(hours) %>:<%= Util.count_display(minutes) %>:<%= Util.count_display(seconds) %></p>
                    <%#  <button phx-click="final-score">Final Results</button> %>
                 </td>
                 <td><%= @contest.start_time %></td>
    """
  end

  defp start_or_pause_button(assigns, "running") do
    ~L"""
    <button phx-click="pause" phx-value-contest='<%= @contest.name %>'>Pause</button>
    """
  end

  defp start_or_pause_button(assigns, _) do
    ~L"""
    <button phx-click="start" phx-value-contest='<%= @contest.name %>'>Start</button>
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
