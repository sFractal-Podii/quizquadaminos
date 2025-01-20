defmodule QuadblockquizWeb.ContestsLive.ContestComponent do
  @moduledoc """
  Component to compatmentalize contests
  """
  use QuadblockquizWeb, :live_component
  import Phoenix.Component

  alias Quadblockquiz.Accounts.User
  alias Quadblockquiz.Contests
  alias Quadblockquiz.Contests.Contest
  alias Quadblockquiz.Util
  alias QuadblockquizWeb.Router.Helpers, as: Routes

  @impl true
  def mount(socket) do
    {:ok, socket |> assign(editing_date?: false, rsvped?: false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="md:table-row">
      <div class="hidden md:table-cell md:p-4">{@contest.name}</div>
      <%= if @current_user.admin? do %>
        <div class="hidden md:table-cell md:p-4">{start_or_pause_button(assigns, @contest)}</div>
        <div class="hidden md:table-cell md:p-4">
          <button
            class={
              "#{maybe_disable_button(@contest)} #{if contest_running?(@contest), do: "red"} icon-button"
            }
            phx-click="stop"
            phx-value-contest={@contest.name}
            disabled={maybe_disable_button(@contest)}
          >
            <i class="fas fa-stop-circle fa-2x"></i>
          </button>
        </div>
      <% end %>
      <div class="hidden md:table-cell md:p-4">{timer_or_final_result(assigns, @contest)}</div>
      <div class="hidden md:table-cell md:p-4">{contest_date(assigns, @contest)}</div>
      <div class="hidden md:table-cell md:p-4">{truncate_date(@contest.start_time)}</div>
      <div class="hidden md:table-cell md:p-4">{truncate_date(@contest.end_time)}</div>
      <div class="hidden md:table-cell md:p-4">{rsvp_or_results_button(assigns, @contest)}</div>
      <div class="flex rounded-lg flex-row shadow md:hidden justify-center p-4 gap-x-12 border border-t-0 mb-4">
        <div class="flex flex-col space-y-2">
          <div class="heading-3 text-blue-500 text-lg font-normal tracking-wide">
            {@contest.name}
          </div>
          <div class="inline-flex space-x-4">
            <p class="text-gray-400 font-normal text-xs">Date:</p>
            <p class="text-sm font-light tracking-wide">{contest_date(assigns, @contest)}</p>
          </div>
          <div class="inline-flex space-x-4">
            <p class="text-gray-400 font-normal text-xs">Start:</p>
            <p class="text-sm font-light tracking-wide">{truncate_date(@contest.start_time)}</p>
          </div>
          <div class="inline-flex space-x-4">
            <p class="text-gray-400 font-normal text-xs">End:</p>
            <p class="pl-1 text-sm font-light tracking-wide">
              {truncate_date(@contest.end_time)}
            </p>
          </div>
          <div>
            <p class="text-sm font-light tracking-wide">
              {timer_or_final_result(assigns, @contest)}
            </p>
          </div>
        </div>
        <div>
          <%= if @contest.status == :stopped do %>
            <i class="fas fa-medal fa-3x text-blue-400"></i>
          <% else %>
            <i class="far fa-envelope fa-3x text-blue-400"></i>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def update_many(assigns_sockets) do
    list_of_ids = Enum.map(assigns_sockets, fn {assigns, _sockets} -> assigns.id end)

    contests =
      list_of_ids
      |> Contests.select_contests_by_id()
      |> Map.new()

    Enum.map(assigns_sockets, fn {assigns, socket} ->
      assign(socket,
        contest: contests[assigns.id] |> Contests.load_contest_vitual_fields(),
        rsvped?: Contests.user_rsvped?(assigns.current_user, contests[assigns.id]),
        current_user: assigns.current_user,
        time_remaining: time_remaining(contests[assigns.id])
      )
    end)
  end

  defp start_or_pause_button(assigns, contest) do
    assigns = assign_new(assigns, :contest, fn -> contest end)

    ~H"""
    <%= if @contest.status == :running do %>
      <button
        class="{if @contest.end_time, do: 'disabled' }  icon-button"
        phx-click="restart"
        phx-value-contest={@contest.name}
        {if @contest.end_time, do: [{"disabled", true}], else: [] }
      >
        <i class="fas fa-undo fa-2x"></i>
      </button>
    <% else %>
      <button
        class="{if @contest.end_time, do: 'disabled' }  icon-button"
        phx-click="start"
        phx-value-contest={@contest.name}
        {if @contest.end_time, do: [{"disabled", true}], else: [] }
      >
        <i class="fas fa-play-circle fa-2x"></i>
      </button>
    <% end %>
    """
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
    ~H"""
    <% {hours, minutes, seconds} = @contest.time_elapsed |> to_human_time() %>
    <p>
      {Util.count_display(hours)}:{Util.count_display(minutes)}:{Util.count_display(seconds)}
    </p>
    """
  end

  defp timer_or_final_result(assigns, %Contest{status: :future}) do
    ~H"""
    <%= if @time_remaining do %>
      <% {days, hours, minutes, seconds} = @time_remaining |> Util.to_human_time() %>
      <p>
        {Util.count_display(days)} days {Util.count_display(hours)}h {Util.count_display(minutes)}m {Util.count_display(
          seconds
        )}s
      </p>
    <% else %>
      <p>Date not yet set</p>
    <% end %>
    """
  end

  defp timer_or_final_result(assigns, contest) do
    assigns = assign_new(assigns, :contest, fn -> contest end)

    if contest.end_time do
      ~H"""
      <button class="invisible md:visible md:bg-blue-600 md:p-2 md:rounded md:w-32 md:text-white">
        <.link navigate={Routes.contests_path(@socket, :show, @contest)}>Final Results</.link>
      </button>
      """
    end
  end

  def contest_date(
        %{current_user: %{admin?: true}, editing_date?: false} = assigns,
        %Contest{contest_date: nil} = contest
      ) do
    assigns = assign_new(assigns, :contest, fn -> contest end)

    ~H"""
    <button phx-click="add_contest_date" phx-value-contest={@contest.name} phx-target={@myself}>
      Add
    </button>
    """
  end

  def contest_date(%{current_user: %{admin?: true}, editing_date?: true} = assigns, _contest) do
    ~H"""
    <.form :let={_f} for={:count} phx-submit={:save_date} phx-target={@myself}>
      <input type="datetime-local" id="contest_date" name="contest_date" />
      <button>Save</button>
    </.form>
    """
  end

  def contest_date(%{current_user: %{admin?: true}, editing_date?: false} = assigns, contest) do
    assigns = assign_new(assigns, :contest, fn -> contest end)

    ~H"""
    {truncate_date(@contest.contest_date)}
    <button
      class="button-clear"
      phx-click="edit_contest_date"
      phx-value-contest={@contest.name}
      phx-target={@myself}
    >
      <i class="fas fa-edit fa-2x"></i>
    </button>
    """
  end

  def contest_date(assigns, contest) do
    assigns = assign_new(assigns, :contest, fn -> contest end)

    ~H"""
    {truncate_date(@contest.contest_date)}
    """
  end

  defp rsvp_or_results_button(assigns, %Contest{status: :running} = contest) do
    assigns = assign_new(assigns, :contest, fn -> contest end)

    ~H"""
    <.link
      navigate={Routes.contests_path(@socket, :show, @contest)}
      class="md:bg-blue-600 md:flex md:items-center md:justify-center md:rounded md:w-32 md:h-10 md:text-white"
    >
      Live Results
    </.link>
    """
  end

  defp rsvp_or_results_button(%{current_user: %User{uid: id}} = assigns, _contest)
       when id in [nil, "anonymous"] do
    ~H"""
    <button class="md:bg-blue-600 md:p-2 md:rounded md:w-32 md:text-white md:opacity-60 md:cursor-not-allowed">
      RSVP
    </button>
    """
  end

  defp rsvp_or_results_button(%{current_user: %User{email: nil}} = assigns, %Contest{
         status: :future
       }) do
    ~H"""
    <button phx-click="ask-for-email">RSVP</button>
    """
  end

  defp rsvp_or_results_button(assigns, %Contest{status: :future} = contest) do
    assigns = assign_new(assigns, :contest, fn -> contest end)

    ~H"""
    <%= if @rsvped? do %>
      <button
        class="md:bg-red-600 md:p-2 md:rounded md:w-40  md:text-white"
        phx-click="cancel_rsvp"
        phx-target={@myself}
        phx-value-contest_id={@contest.id}
      >
        CANCEL RSVP
      </button>
    <% else %>
      <button
        class="md:bg-blue-600 md:p-2 md:rounded md:w-32 md:text-white"
        phx-click="rsvp"
        phx-target={@myself}
        phx-value-contest_id={@contest.id}
      >
        RSVP
      </button>
    <% end %>
    """
  end

  defp rsvp_or_results_button(assigns, %Contest{}) do
    ~H"""
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
