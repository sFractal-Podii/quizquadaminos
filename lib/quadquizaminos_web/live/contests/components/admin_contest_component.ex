defmodule QuadquizaminosWeb.ContestsLive.AdminContestComponent do
  @moduledoc """
  Component to compatmentalize contests
  """
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form

  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.Contests.Contest
  alias Quadquizaminos.Contests
  alias QuadquizaminosWeb.Router.Helpers, as: Routes
  alias Quadquizaminos.Util

  @impl true
  def mount(socket) do
    {:ok, socket |> assign(editing_date?: false, rsvped?: false)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <td><%= @contest.name%></td>
      <td> <%= start_or_pause_button(assigns,@contest) %> </td>
      <td>
      <button class="<%= maybe_disable_button(@contest) %> <%= if contest_running?(@contest), do: "red" %> icon-button" phx-click="stop" phx-value-contest='<%= @contest.name %>' <%= maybe_disable_button(@contest) %>><i class="fas fa-stop-circle fa-2x"></i></button>
      </td>

    <td><%= timer_or_final_result(assigns, @contest) %> </td>
    <td><%= contest_date(assigns, @contest)%> </td>
    <td><%= truncate_date(@contest.start_time) %></td>
    <td><%= truncate_date(@contest.end_time) %></td>
    """
  end

  @impl true
  def preload(list_of_assigns) do
    list_of_assigns
    |> Enum.map(fn assigns ->
      contest =
        Contests.get_contest(assigns.id)
        |> Contests.load_contest_vitual_fields()

      Map.put(assigns, :contest, contest)
    end)
  end

  @impl true
  def update(assigns, socket) do
    contest = assigns.contest

    rsvped? = Contests.user_rsvped?(assigns.current_user, contest)

    {:ok,
     assign(socket,
       contest: contest,
       current_user: assigns.current_user,
       rsvped?: rsvped?,
       time_remaining: time_remaining(contest)
     )}
  end

  defp start_or_pause_button(assigns, contest) do
    if contest.status == :running do
      ~L"""
      <button class= "<%= if contest.end_time, do: 'disabled' %> icon-button" phx-click="restart" phx-value-contest='<%= contest.name  %>' <%= if contest.end_time, do: 'disabled' %> ><i class="fas fa-undo fa-2x"></i></button>
      """
    else
      ~L"""
      <button class= "<%= if contest.end_time, do: 'disabled' %>  icon-button" phx-click="start" phx-value-contest='<%= contest.name %>' <%= if contest.end_time, do: 'disabled' %>><i class="fas fa-play-circle fa-2x"></i></button>
      """
    end
  end

  def contest_running?(contest) do
    contest.status == :running
  end

  def maybe_disable_button(contest) do
    if contest.end_time || not contest_running?(contest) do
      "disabled"
    end
  end

  defp timer_or_final_result(assigns, %Contest{status: :running}) do
    ~L"""
    <% {hours, minutes, seconds} = @contest.time_elapsed |> to_human_time() %>
    <p><%= Util.count_display(hours) %>:<%= Util.count_display(minutes) %>:<%= Util.count_display(seconds) %></p>
    """
  end

  defp timer_or_final_result(assigns, %Contest{status: :future}) do
    ~L"""
    <%= if @time_remaining do %>
    <% {days, hours, minutes, seconds} = @time_remaining |> Util.to_human_time() %>
    <p><%= Util.count_display(days) %> days <%= Util.count_display(hours) %>h <%= Util.count_display(minutes) %>m <%= Util.count_display(seconds) %>s</p>
    <% else %>
    <p> Date not yet set </p>
    <% end %>
    """
  end

  defp timer_or_final_result(assigns, contest) do
    if contest.end_time do
      ~L"""
      <%= live_redirect "Final Results", class: "button",  to: Routes.contests_path(@socket, :show, contest)%>
      """
    end
  end

  def contest_date(
        %{editing_date?: false} = assigns,
        %Contest{contest_date: nil} = contest
      ) do
    ~L"""
    <button phx-click="add_contest_date" phx-value-contest='<%= contest.name%>' phx-target="<%= @myself%>">Add</button>
    """
  end

  def contest_date(%{editing_date?: true} = assigns, _contest) do
    ~L"""
      <%= form_for :count, "#", [phx_submit: :save_date, phx_target: @myself] %>
        <input type="datetime-local" id="contest_date" name="contest_date">
        <button>Save</button>
      </form>
    """
  end

  def contest_date(%{editing_date?: false} = assigns, contest) do
    ~L"""
    <%= truncate_date(contest.contest_date) %>
    <button class="button-clear" phx-click="edit_contest_date" phx-value-contest='<%= contest.name%>' phx-target="<%= @myself%>"><i class="fas fa-edit fa-2x"></i></button>
    """
  end

  def contest_date(assigns, contest) do
    ~L"""
    <%= truncate_date(contest.contest_date) %>
    """
  end

  def truncate_date(nil) do
    nil
  end

  def truncate_date(date) do
    DateTime.truncate(date, :second)
  end

  defp to_human_time(seconds) do
    hours = div(seconds, 3600)
    rem = rem(seconds, 3600)
    minutes = div(rem, 60)
    rem = rem(rem, 60)
    seconds = div(rem, 1)
    {hours, minutes, seconds}
  end

  defp time_remaining(%Contest{contest_date: date}) do
    case date do
      nil -> nil
      date -> DateTime.diff(date, DateTime.utc_now())
    end
  end

  @impl true
  def handle_event(event, _params, socket)
      when event in ["add_contest_date", "edit_contest_date"] do
    {:noreply, socket |> assign(editing_date?: true)}
  end

  @impl true
  def handle_event("save_date", %{"contest_date" => date}, socket) do
    {:ok, date, 0} = DateTime.from_iso8601(date <> ":00Z")

    socket =
      case Contests.update_contest(socket.assigns.contest, %{contest_date: date}) do
        {:ok, contest} -> socket |> assign(editing_date?: false, contest: contest)
        _ -> socket
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("rsvp", %{"contest_id" => id} = attrs, socket) do
    socket =
      case Contests.create_rsvp(attrs, socket.assigns.current_user) do
        {:ok, _rsvp} ->
          socket |> assign(:rsvped?, true)

        {:error, _changeset} ->
          socket |> assign(:rsvped?, false)
      end

    id =
      case Integer.parse(id) do
        {int, _} -> int
        :error -> id
      end

    send(self(), {:update_component, contest_id: id})
    {:noreply, socket}
  end
end
