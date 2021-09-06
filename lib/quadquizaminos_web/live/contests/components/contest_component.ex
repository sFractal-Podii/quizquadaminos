defmodule QuadquizaminosWeb.ContestsLive.ContestComponent do
  @moduledoc """
  Component to compatmentalize contests
  """
  use Phoenix.LiveComponent
  import Phoenix.HTML.Form

  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.Contests.Contest
  alias Quadquizaminos.Contests
  alias Quadquizaminos.Contests.RSVP
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
    <td><%= timer_or_final_result(assigns, @contest) %> </td>
    <td><%= truncate_date(@contest.contest_date) %> </td>
    <td><%= truncate_date(@contest.start_time) %></td>
    <td><%= truncate_date(@contest.end_time) %></td>
    <td><%= rsvp_or_results_button(assigns, @contest) %></td>
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

  def contest_running?(contest) do
    contest.status == :running
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

  defp rsvp_or_results_button(assigns, %Contest{status: :running} = contest) do
    ~L"""
    <%= live_redirect "Live Results", class: "button",  to: Routes.contests_path(@socket, :show, contest)%>
    """
  end

  defp rsvp_or_results_button(%{current_user: %User{uid: id}} = assigns, _contest)
       when id in [nil, "anonymous"] do
    ~L"""
    <button disabled>  RSVP </button>
    """
  end

  defp rsvp_or_results_button(assigns, %Contest{status: :future} = contest) do
    ~L"""
    <%= if @rsvped? do %>
      <button class="red" phx-click="cancel_rsvp" phx-target="<%= @myself %>" phx-value-contest_id="<%= contest.id %>"> CANCEL </button>
    <% else %>
      <button phx-click="rsvp" phx-target="<%= @myself %>" phx-value-contest_id="<%= contest.id %>" > RSVP </button>
    <% end %>
    """
  end

  defp rsvp_or_results_button(assigns, %Contest{}) do
    ~L"""
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

  @impl true
  def handle_event("cancel_rsvp", %{"contest_id" => id}, socket) do
    id = String.to_integer(id)

    socket =
      case Contests.cancel_rsvp(id, socket.assigns.current_user) do
        {:ok, _rsvp} ->
          socket |> assign(:rsvped?, false)

        {:error, _changeset} ->
          socket |> assign(:rsvped?, true)
      end

    {:noreply, socket}
  end
end
