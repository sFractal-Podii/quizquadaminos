defmodule QuadblockquizWeb.ContestsLive do
  @moduledoc """
  This is a module that does the following:
  - Finds the already started contests
  - Add the created contest to the socket
  - Add the created contest to the contest list
  - Ensures that the ended contest does not appear twice in the contest list
  - Calculates the counter timer
  """
  use QuadblockquizWeb, :live_view

  import Phoenix.HTML.Form
  alias Quadblockquiz.Accounts
  alias Quadblockquiz.Accounts.User
  alias Quadblockquiz.Contests
  alias Quadblockquiz.GameBoard
  alias QuadblockquizWeb.ContestsLive.ContestComponent

  def mount(_params, session, socket) do
    case socket.assigns.live_action do
      :show ->
        :timer.send_interval(1000, self(), :update_records)

      :index ->
        :timer.send_interval(1000, self(), :update_component_timer)

      _ ->
        nil
    end

    current_user = session["uid"] |> current_user()

    {:ok,
     socket
     |> assign(
       current_user: current_user,
       contests: Contests.list_contests(),
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

  def handle_event("validate", %{"contest" => params}, socket) do
    changeset =
      %Contests.Contest{}
      |> Contests.change_contest(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event(
        "save",
        %{"contest" => %{"name" => name, "contest_date" => contest_date, "pin" => pin}},
        socket
      ) do
    socket = socket |> _create_contest(name, contest_date, pin)
    {:noreply, socket |> redirect(to: Routes.admin_contests_path(socket, :index))}
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
    sorter = String.to_atom(socket.assigns.sort_by)
    contest_name = String.to_atom(contest.name)

    if :ets.whereis(contest_name) != :undefined do
      records =
        contest_name
        |> :ets.tab2list()
        |> Enum.map(fn {uid, record, name} ->
          game_board = struct(%GameBoard{}, record)
          %{game_board | user: %User{name: name, uid: uid}}
        end)
        |> Enum.sort_by(&Map.get(&1, sorter), :desc)

      send_update(QuadblockquizWeb.ContestFinalResultComponent,
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
      unless Contests.ended_contest?(contest.id) do
        send(self(), {:update_component, contest_id: contest.id})
      end
    end)

    {:noreply, socket}
  end

  def handle_info({:update_component, contest_id: contest_id}, socket) do
    send_update(ContestComponent, id: contest_id, current_user: socket.assigns.current_user)
    {:noreply, socket}
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

  defp _create_contest(socket, contest_name, "", pin) do
    contests = socket.assigns.contests

    case Contests.create_contest(%{name: contest_name, contest_date: nil, pin: pin}) do
      {:ok, contest} ->
        assign(socket,
          contests: contests ++ [contest],
          changeset: Contests.change_contest(%Contests.Contest{})
        )

      _ ->
        socket
    end
  end

  defp _create_contest(socket, contest_name, contest_date, pin) do
    contests = socket.assigns.contests
    {:ok, contest_date, 0} = DateTime.from_iso8601(contest_date <> ":00Z")

    case Contests.create_contest(%{name: contest_name, contest_date: contest_date, pin: pin}) do
      {:ok, contest} ->
        assign(socket,
          contests: contests ++ [contest],
          changeset: Contests.change_contest(%Contests.Contest{})
        )

      _ ->
        socket
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
    ids = Application.get_env(:quadblockquiz, :github_ids)

    current_user in (ids |> Enum.map(&(&1 |> to_string())))
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
