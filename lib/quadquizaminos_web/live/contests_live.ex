defmodule QuadquizaminosWeb.ContestsLive do
  use QuadquizaminosWeb, :live_view

  import Phoenix.LiveView.Helpers
  alias Quadquizaminos.Accounts
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.Contests
  alias Quadquizaminos.GameBoard
  alias Quadquizaminos.Util
  alias QuadquizaminosWeb.ContestsLive.ContestComponent

  @conference_date Application.compile_env(:quadquizaminos, :conference_date)

  def mount(_params, session, socket) do
    case socket.assigns.live_action do
      :show ->
        :timer.send_interval(1000, self(), :update_records)

      :index ->
        :timer.send_interval(1000, self(), :update_component_timer)

      _ ->
        nil
    end

    countdown_interval = DateTime.diff(@conference_date, DateTime.utc_now())
    current_user = session["uid"] |> current_user()

    {:ok,
     socket
     |> assign(
       current_user: current_user,
       contests: Contests.list_contests(),
       countdown_interval: countdown_interval,
       contest_records: [],
       contest_id: nil,
       editing_date?: false,
       changeset: Contests.change_contest(%Contests.Contest{}),
       modal: false,
       page: 1,
       sort_by: "score"
     )}
  end

  def handle_event("add_contest_date", %{"contest" => name}, socket) do
    contests =
      Enum.map(socket.assigns.contests, fn contest ->
        if contest.name == name do
          %{contest | add_contest_date: true}
        else
          contest
        end
      end)

    {:noreply, assign(socket, contests: contests, editing_date?: true)}
  end

  def handle_event("edit_contest_date", %{"contest" => name}, socket) do
    contests =
      Enum.map(socket.assigns.contests, fn contest ->
        if contest.name == name do
          %{contest | editing_date?: true}
        else
          contest
        end
      end)

    {:noreply, assign(socket, contests: contests, editing_date?: true)}
  end

  def handle_event("validate", params, socket) do
    changeset =
      %Contests.Contest{}
      |> Contests.change_contest(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("save", %{"name" => name, "contest_date" => contest_date}, socket) do
    {:noreply, socket |> _create_contest(name, contest_date)}
  end

  def handle_event("start", %{"contest" => name}, socket) do
    {:noreply, start_or_resume_contest(socket, name)}
  end

  def handle_event("restart", %{"contest" => name}, socket) do
    {:noreply, _restart_contest(socket, name)}
  end

  def handle_event("ask-for-email", _, socket) do
    {:noreply, socket |> assign(modal: true)}
  end

  def handle_event("stop", %{"contest" => name}, socket) do
    {:noreply, _end_contest(socket, name)}
  end

  def handle_info(:update_records, %{assigns: %{contest: contest}} = socket) do
    contest_name = String.to_atom(contest.name)

    if :ets.whereis(contest_name) != :undefined do
      records =
        contest_name
        |> :ets.tab2list()
        |> Enum.map(fn {uid, record, name} ->
          game_board = struct(%GameBoard{}, record)
          %{game_board | user: %User{name: name, uid: uid}}
        end)
        |> Enum.sort_by(& &1.score, :desc)

      send_update(QuadquizaminosWeb.ContestFinalResultComponent,
        id: "final_result",
        contest: socket.assigns.contest,
        contest_records: records
      )
    end

    {:noreply, socket}
  end

  def handle_info(:update_records, socket) do
    {:noreply, socket}
  end

  def handle_info(:update_component_timer, socket) do
    Enum.each(socket.assigns.contests, fn contest ->
      if Contests.contest_running?(contest.name) do
        send(self(), {:update_component, contest_id: contest.id})
      end
    end)

    {:noreply, socket}
  end

  def handle_info({:update_component, contest_id: contest_id}, socket) do
    send_update(ContestComponent, id: contest_id, current_user: socket.assigns.current_user)
    {:noreply, socket}
  end

  def handle_info(:count_down, socket) do
    countdown_interval = DateTime.diff(@conference_date, DateTime.utc_now())
    {:noreply, socket |> assign(countdown_interval: countdown_interval)}
  end

  def handle_info({:update_user, assigns}, socket) do
    {:noreply,
     socket
     |> assign(assigns)
     |> assign(modal: false)}
  end

  def handle_params(%{"id" => id, "page" => page, "sort_by" => sorter}, uri, socket) do
    page = String.to_integer(page)
    contest = Contests.get_contest(String.to_integer(id))

    {:noreply,
     assign(socket,
       contest: contest,
       current_uri: uri,
       page: page,
       sort_by: sorter,
       contest_records: Contests.contest_game_records(contest, page, sorter)
     )}
  end

  def handle_params(%{"id" => id}, uri, socket) do
    contest = Contests.get_contest(String.to_integer(id))
    {:noreply, assign(socket, contest: contest, current_uri: uri)}
  end

  def handle_params(_params, uri, socket) do
    current_user = socket.assigns.current_user

    # you cannot perfom admin tasks when not in admin scope
    current_user =
      if URI.parse(uri).path == "/contests" do
        %{current_user | admin?: false}
      else
        current_user
      end

    {:noreply, socket |> assign(current_user: current_user, current_uri: uri)}
  end

  defp _create_contest(socket, contest_name, "") do
    contests = socket.assigns.contests

    case Contests.create_contest(%{name: contest_name, contest_date: nil}) do
      {:ok, contest} -> assign(socket, contests: contests ++ [contest])
      _ -> socket
    end
  end

  defp _create_contest(socket, contest_name, contest_date) do
    contests = socket.assigns.contests
    {:ok, contest_date, 0} = DateTime.from_iso8601(contest_date <> ":00Z")

    case Contests.create_contest(%{name: contest_name, contest_date: contest_date}) do
      {:ok, contest} -> assign(socket, contests: contests ++ [contest])
      _ -> socket
    end
  end

  defp _start_contest(socket, name) do
    contests =
      Enum.map(socket.assigns.contests, fn
        contest ->
          if contest.name == name do
            {:ok, {:ok, started_contest}} = Contests.start_contest(name)
            started_contest
          else
            contest
          end
      end)

    assign(socket, contests: contests)
  end

  defp _restart_contest(socket, name) do
    contests =
      Enum.map(socket.assigns.contests, fn
        contest ->
          if contest.name == name do
            {:ok, restarted_contest} = Contests.restart_contest(name)
            restarted_contest
          else
            contest
          end
      end)

    assign(socket, contests: contests)
  end

  defp _end_contest(socket, name) do
    contests =
      Enum.map(socket.assigns.contests, fn
        contest ->
          if contest.name == name do
            {:ok, {:ok, ended_contest}} = Contests.end_contest(name)
            ended_contest
          else
            contest
          end
      end)

    assign(socket, contests: contests)
  end

  defp start_or_resume_contest(socket, name) do
    if name in Contests.active_contests_names() && GenServer.whereis(name |> String.to_atom()) do
      Contests.resume_contest(name)
      socket
    else
      _start_contest(socket, name)
    end
  end

  defp admin?(current_user) do
    ids = Application.get_env(:quadquizaminos, :github_ids)

    current_user in (ids |> Enum.map(&(&1 |> to_string())))
  end

  def countdown_timer(_assigns, true = _admin?), do: ""

  def countdown_timer(assigns, _) do
    ~L"""
    <div class="container">
            <section class="phx-hero">
                <h1>Contest countdown </h1>
                <div class="row">
                    <div class="column column-25">
                        <% {days, hours, minutes, seconds} = Util.to_human_time(@countdown_interval) %>

                        <h2><%= days |> Util.count_display() %></h2>
                        <h2>DAYS</h2>
                    </div>
                    <div class="column column-25">
                        <h2><%= Util.count_display(hours)%></h2>
                        <h2>HOURS</h2>
                    </div>
                    <div class="column column-25">
                        <h2><%=Util.count_display(minutes)%></h2>
                        <h2>MINUTES</h2>
                    </div>
                    <div class="column column-25">
                        <h2><%=Util.count_display(seconds)%></h2>
                        <h2>SECONDS</h2>
                    </div>
                </div>
                <h3>Contest coming soon</h3>
            </section>
        </div>
    """
  end

  defp group_contest_by_status(contests) do
    contests
    |> Enum.map(fn contest ->
      %{contest | status: Contests.contest_status(contest.name)}
    end)
    |> Enum.group_by(fn contest -> contest.status end)
    |> Enum.sort({:asc, Contests.Contest})
  end

  defp status(:stopped), do: "Past"

  defp status(status) do
    status |> to_string() |> Macro.camelize()
  end

  defp current_user(nil) do
    %User{uid: nil, admin?: false}
  end

  defp current_user(uid) do
    case Accounts.get_user(uid) do
      nil -> %User{uid: "anonymous", name: "anonymous"}
      %User{} = user -> %{user | admin?: admin?(uid)}
    end
  end
end
