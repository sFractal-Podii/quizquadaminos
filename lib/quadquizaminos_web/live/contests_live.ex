defmodule QuadquizaminosWeb.ContestsLive do
  use Phoenix.LiveView

  import Phoenix.LiveView.Helpers
  import Phoenix.HTML, only: [raw: 1]
  import Phoenix.HTML.{Form, Tag}
  alias Quadquizaminos.Contests
  alias QuadquizaminosWeb.ContestsLive.ContestComponent
  alias Quadquizaminos.Accounts
  alias Quadquizaminos.Contest
  alias Quadquizaminos.Accounts.User
  alias Quadquizaminos.Util
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  @conference_date Application.fetch_env!(:quadquizaminos, :conference_date)

  def mount(_params, %{"uid" => uid}, socket) do
    :timer.send_interval(1000, self(), :count_down)
    countdown_interval = DateTime.diff(@conference_date, DateTime.utc_now())
    QuadquizaminosWeb.Endpoint.subscribe("contest_scores")

    {:ok,
     socket
     |> assign(
       current_user: uid |> current_user(),
       contests: Contests.list_contests(),
       countdown_interval: countdown_interval,
       contest_records: [],
       contest_id: nil,
       editing_date?: false
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

  def handle_event("save", %{"key" => "Enter", "value" => contest_name}, socket) do
    {:noreply, socket |> _create_contest(contest_name)}
  end

  def handle_event("start", %{"contest" => name}, socket) do
    {:noreply, start_or_resume_contest(socket, name)}
  end

  def handle_event("restart", %{"contest" => name}, socket) do
    {:noreply, _restart_contest(socket, name)}
  end

  def handle_event("stop", %{"contest" => name}, socket) do
    QuadquizaminosWeb.Endpoint.broadcast(
      "contest_record",
      "record_contest_scores",
      name
    )

    {:noreply, _end_contest(socket, name)}
  end

  def handle_info({:update_timer, contest_id: contest_id}, socket) do
    send_update(ContestComponent, id: contest_id, current_user: socket.assigns.current_user)
    {:noreply, socket}
  end

  def handle_info(:count_down, socket) do
    countdown_interval = DateTime.diff(@conference_date, DateTime.utc_now())
    {:noreply, socket |> assign(countdown_interval: countdown_interval)}
  end

  def handle_info(%{event: "current_scores", payload: payload}, socket) do
    contest_records = socket.assigns.contest_records

    contest_records =
      (contest_records ++ payload)
      |> Enum.sort_by(& &1.score, :desc)
      |> Enum.uniq_by(& &1.uid)
      |> Enum.take(10)

    contest_records =
      case socket.assigns.contest_id do
        nil -> contest_records
        contest_id -> contest_live_records(contest_records, contest_id)
      end

    {:noreply, socket |> assign(contest_records: contest_records)}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    {:noreply, assign(socket, id: id, contest_records: contest_records(id))}
  end

  def handle_params(_params, _uri, socket) do
    {:noreply, socket}
  end

  defp contest_live_records(records, contest_id) do
    Enum.filter(records, fn record -> record.contest_id == contest_id end)
  end

  defp contest_records(contest_id) do
    case String.to_integer(contest_id) |> Contests.get_contest() do
      nil ->
        []

      contest ->
        Contests.contest_game_records(contest)
    end
  end

  defp _create_contest(socket, contest_name) do
    contests = socket.assigns.contests

    case Contests.create_contest(%{name: contest_name}) do
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

  defp display_text_input(true = _admin?) do
    """
    <input type="text" phx-keydown="save"  phx-key="Enter">
    """
  end

  defp display_text_input(_), do: ""

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

  defp current_user(uid) do
    case Accounts.get_user(uid) do
      nil -> %User{uid: "anonymous", name: "anonymous"}
      %User{} = user -> %{user | admin?: admin?(uid)}
    end
    |> IO.inspect()
  end
end
