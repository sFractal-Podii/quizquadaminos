defmodule QuadquizaminosWeb.TetrisLive do
  use Phoenix.LiveView
  import Phoenix.HTML.Form
  import QuadquizaminosWeb.ErrorHelpers
  import Phoenix.HTML, only: [raw: 1]
  alias Quadquizaminos.Contests
  import QuadquizaminosWeb.LiveHelpers
  alias Quadquizaminos.Accounts
  alias Quadquizaminos.Accounts.User
  alias QuadquizaminosWeb.SvgBoard
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  alias Quadquizaminos.{
    Bottom,
    Brick,
    Hints,
    Points,
    QnA,
    Speed,
    Tetris,
    Threshold
  }

  alias Quadquizaminos.GameBoard.Records

  @debug false
  @box_width 20
  @box_height 20

  def mount(_param, %{"uid" => user_id}, socket) do
    :timer.send_interval(50, self(), :tick)
    current_user = user_id |> current_user()

    has_email? =
      if(current_user.name == "anonymous" or current_user.email) do
        true
      else
        false
      end

    {:ok,
     socket
     |> assign(
       start_timer: false,
       current_user: current_user,
       active_contests: Contests.active_contests(),
       contest_id: nil,
       choosing_contest: false,
       has_email?: has_email?,
       user_changeset: Accounts.change_user(current_user)
     )
     |> init_game
     |> start_game()}
  end

  def render(%{state: :starting} = assigns) do
    ~L"""
      <div class ="container">
        <div class="row">
            <div class="column column-50 column-offset-25">
              <h1>Welcome to QuadBlockQuiz!</h1>
              <%= if @has_email? do %>
              <%= join_contest(assigns) %>
              <% else %>
              <%= ask_for_email(assigns) %>
              <% end %>
            </div>
        </div>
      </div>
    """
  end

  def render(%{state: :game_over} = assigns) do
    ~L"""
    <div class="container">
      <div class="row">
        <div class="column column-50 column-offset-25">
          <h1>Bankruptcy!</h1>
            <h2>Your score: <%= @score %></h2>
            <p>You are bankrupt
            due to a cyberattack,
            or due to a lawsuit,
            or maybe because you let your supply chain get to long.
            Or maybe you were too busy answering cybersecurity questions
            and not paying attention to business.
            Or maybe you just hit quit :-).
            </p>
            <hr>
            <%= raw SvgBoard.svg_head() %>
            <%= for row <- [Map.values(@bottom)] do %>
              <%= for {x, y, color} <- row do %>
              <svg>
               <%= raw SvgBoard.box({x, y}, color)%>
               </svg>
                <% end %>
            <% end %>
            <%= raw SvgBoard.svg_foot() %>
            <hr>
            <%= live_redirect "Play again?", to: Routes.tetris_path(@socket, :tetris), class: "button" %>
              </div>
        <div class="column column-25 column-offset-25">
        <p><%= @brick_count %> QuadBlocks dropped</p>
        <p><%= @row_count %> rows cleard</p>
        <p><%= @correct_answers %> questions answered correctly</p>
        <p>Tech Debt: <%= @tech_vuln_debt + @tech_lic_debt %></p>
        </div>
      </div>
    </div>
     <%= debug(assigns) %>

    """
  end

  def render(assigns) do
    ~L"""
      <div class="container" id="gamearea" phx-hook="DisableArrow">
        <div class="row">
          <div class="column column-75">
              <div class="row">
                <div class="column column-25 column-offset-25">
                    <h1><%= @score %></h1>
                    <h2>Score</h2>
                    <hr><p>Speed: <%= Speed.speed_name(@speed) %></p>
                    <p><%= @brick_count %> QuadBlocks</p>
                    <p><%= @row_count %> Rows</p>
                    <p><%= @correct_answers %> Answers</p>
                    <p>Tech Debt: <%= @tech_vuln_debt + @tech_lic_debt %></p>
                    <hr>
                </div>
                <div class="column column-50">
                <%= if @modal do %>
                <%= live_modal @socket,  QuadquizaminosWeb.QuizModalComponent, id: 1, powers: @powers, score: @score,  modal: @modal, qna: @qna, categories: @categories, category: @category, return_to: Routes.tetris_path(QuadquizaminosWeb.Endpoint, :tetris)%>
                <% end %>
                <%= if @super_modal do %>
                <%= live_modal @socket,  QuadquizaminosWeb.SuperpModalComponent, id: 3, powers: @powers,  super_modal: @super_modal, return_to: Routes.tetris_path(QuadquizaminosWeb.Endpoint, :tetris)%>
                <% end %>
                  <div phx-window-keydown="keydown" class="grid">
                    <%= raw SvgBoard.svg_head() %>
                    <%= for x1 <- 1..10, y1 <- 1..20 do %>
                    <% {x, y} = SvgBoard.to_pixels( {x1, y1}, @box_width, @box_height ) %>
                    <rect phx-click="add_block" phx-value-x=<%= x1 %> phx-value-y=<%= y1 %>
                    x="<%= x + 1 %>" y="<%= y + 1 %>"
                    class="position-block <%= if @adding_block and block_in_bottom?(@block_coordinates, @bottom), do: "hover-block" %>"
                    width="<%= @box_width - 2 %>" height="<%= @box_height - 1 %>"/>
                    <% end %>

                    <%= for row <- [@tetromino, Map.values(@bottom)] do %>
                      <%= for {x, y, color} <- row do %>
                      <svg phx-click="transform_block" phx-value-x= <%= x %> phx-value-y=<%= y %> phx-value-color= <%= color %>>
                       <%= raw SvgBoard.box({x, y}, color)%>
                          <%= raw deleting_title({x, y}, @deleting_block, block_in_bottom?(x, y, @bottom)) %>
                           <%= raw moving_title(@moving_block, block_in_bottom?(x, y, @bottom))  %>
                       </svg>
                        <% end %>
                    <% end %>

                    <%= raw SvgBoard.svg_foot() %>
                  </div>
                </div>
              </div>
            </div>
            <div class="column column-50">
            <%= raw Hints.tldr(@hint) %>
            </div>
          <br/>
        </div>
    </div>
    <%= debug(assigns) %>
    """
  end

  defp ask_for_email(assigns) do
    ~L"""
    <%= unless @current_user == nil ||  @current_user.email do %>
    <h3> What's your email address? </h3>
    <%= f = form_for @user_changeset, "#", [phx_change: :validate, phx_submit: :update_email] %>
    <%= label f, :email %>
    <%= text_input f, :email, type: :email %>
    <%= error_tag f, :email %>
    <%= text_input f, :uid, type: :hidden %>
    <button> Update Email </button>
    </form>
    <% end %>
    """
  end

  defp join_contest(%{active_contests: []} = assigns) do
    ~L"""
    <button phx-click="start" phx-value-contest="" >Start</button>
    """
  end

  defp join_contest(assigns) do
    ~L"""
    <%= if not @choosing_contest do %>
       <button phx-click="choose_contest">Start</button>
    <% else %>
     <br />
       <h2> Join a contest? </h2>
       <p> Click on the contest below to join </p>
       <%= for contest <- @active_contests do %>
         <button phx-click="start" phx-value-contest="<%= contest.id %>" ><%= contest.name %></button>
       <% end %>
       <br />
       <br />
       <p> Not joining a contest? </p>
       <button phx-click="start" phx-value-contest="" class="button button-outline">Yes, I am Just playing</button>
    <% end %>
    """
  end

  defp pause_game(socket) do
    assign(socket, state: :paused, modal: true)
  end

  defp start_game(socket) do
    assign(socket,
      state: :starting,
      box_width: @box_width,
      modal: false,
      box_height: @box_height
    )
  end

  defp new_game(socket) do
    ## should qna be reset or carryover between games????
    socket
    |> init_game
    |> new_block
    |> show
  end

  def new_block(socket) do
    brick_count = socket.assigns.brick_count + 1
    brick = Brick.new_random()
    assign(socket, brick: brick, brick_count: brick_count)
  end

  def show(socket) do
    brick = socket.assigns.brick

    points =
      brick
      |> Brick.prepare()
      |> Points.move_to_location(brick.location)
      |> Points.with_color(SvgBoard.color(brick), socket.assigns.brick_count)

    assign(socket, tetromino: points)
  end

  defp init_game(socket) do
    socket
    |> assign(adding_block: false)
    |> assign(attack_threshold: 5)
    |> assign(block_coordinates: nil)
    |> assign(bottom: %{})
    |> assign(brick_count: 0)
    |> assign(category: nil, categories: init_categories())
    |> assign(correct_answers: 0)
    |> assign(deleting_block: false)
    |> assign(fix_vuln_or_license: false)
    |> assign(hint: :intro)
    |> assign(lawsuit_threshold: 5)
    |> assign(lic_threshold: 143)
    |> assign(modal: false)
    |> assign(moving_block: false)
    |> assign(powers: [])
    |> assign(qna: %{})
    |> assign(row_count: 0)
    |> assign(score: 0)
    |> assign(speed: 2)
    |> assign(start_time: DateTime.utc_now())
    |> assign(state: :playing)
    |> assign(super_modal: false)
    |> assign(tick_count: 5)
    |> assign(tech_lic_debt: 0)
    |> assign(tech_vuln_debt: 65)
    |> assign(vuln_threshold: 143)
  end

  defp game_record(socket) do
    bottom_block =
      case socket.assigns.bottom do
        nil ->
          nil

        bottom ->
          Enum.into(bottom, %{}, fn {key, value} ->
            {tuple_to_string(key), tuple_to_string(value)}
          end)
      end

    contest =
      Enum.find(socket.assigns.active_contests, fn contest ->
        socket.assigns[:contest_id] == contest.id
      end)

    end_time =
      cond do
        socket.assigns.state == :game_over -> DateTime.utc_now()
        Contests.ended_contest?(socket.assigns[:contest_id]) -> if contest, do: contest.end_time
        true -> nil
      end

    %{
      start_time: socket.assigns.start_time,
      end_time: end_time,
      uid: socket.assigns.current_user.uid,
      score: socket.assigns.score,
      dropped_bricks: socket.assigns.brick_count,
      bottom_blocks: bottom_block,
      uid: socket.assigns.current_user.uid,
      contest_id: socket.assigns.contest_id,
      correctly_answered_qna: socket.assigns.correct_answers
    }
  end

  defp current_user("anonymous") do
    %User{name: "anonymous", uid: "anonymous", admin?: false}
  end

  defp current_user(uid) do
    Accounts.get_user(uid)
  end

  def tuple_to_string({x, y, c}) do
    c = c |> to_string()
    {x, y, c} |> Tuple.to_list() |> to_string()
  end

  def tuple_to_string(value) do
    value |> Tuple.to_list() |> to_string()
  end

  def drop(:playing, socket, fast) do
    old_brick = socket.assigns.brick

    response =
      Tetris.drop(
        old_brick,
        socket.assigns.bottom,
        SvgBoard.color(old_brick),
        socket.assigns.brick_count
      )

    bonus = if fast, do: 2, else: 0

    ended_contest? =
      if is_nil(socket.assigns[:contest_id]),
        do: false,
        else: Contests.ended_contest?(socket.assigns[:contest_id])

    socket =
      socket
      |> assign(brick: response.brick)
      |> assign(bottom: if(response.game_over, do: socket.assigns.bottom, else: response.bottom))
      |> assign(brick_count: socket.assigns.brick_count + response.brick_count)
      |> assign(row_count: socket.assigns.row_count + response.row_count)
      |> assign(
        hint:
          if(response.brick_count > 0,
            do: Hints.next_hint(socket.assigns.hint),
            else: socket.assigns.hint
          )
      )
      |> assign(score: socket.assigns.score + response.score + bonus)
      |> assign(
        state:
          if(response.game_over || ended_contest?,
            do: :game_over,
            else: :playing
          )
      )
      |> cache_contest_game()
      |> maybe_save_game_record()
      |> show
  end

  def drop(_not_playing, socket, _fast), do: socket

  defp cache_contest_game(%{assigns: %{contest_id: nil}} = socket) do
    socket
  end

  defp cache_contest_game(socket) do
    game_record = socket |> game_record() |> Map.delete(:bottom_blocks)
    contest_name = String.to_atom(socket.assigns.contest.name)

    if :ets.whereis(contest_name) != :undefined do
      :ets.insert(contest_name, {socket.assigns.current_user.uid, game_record})
    end

    socket
  end

  defp maybe_save_game_record(socket) do
    if socket.assigns.state == :game_over or Contests.ended_contest?(socket.assigns.contest_id) do
      Records.record_player_game(true, game_record(socket))
    end

    socket
  end

  def move(_direction, %{assigns: %{state: :paused}} = socket), do: socket

  def move(direction, socket) do
    socket
    |> do_move(direction)
    |> show
  end

  def do_move(%{assigns: %{brick: brick, bottom: bottom}} = socket, :left) do
    assign(socket, brick: brick |> Tetris.try_left(bottom))
  end

  def do_move(%{assigns: %{brick: brick, bottom: bottom}} = socket, :right) do
    assign(socket, brick: brick |> Tetris.try_right(bottom))
  end

  def do_move(%{assigns: %{brick: _brick, bottom: bottom}} = socket, :turn) do
    assign(socket, brick: socket.assigns.brick |> Tetris.try_spin_90(bottom))
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      %Accounts.User{}
      |> Accounts.change_user(params)
      |> Map.put(:action, :insert)

    {:noreply, socket |> assign(user_changeset: changeset)}
  end

  def handle_event("update_email", %{"user" => params}, socket) do
    case Accounts.update_email(params) do
      {:ok, user} -> {:noreply, socket |> assign(current_user: user, has_email?: true)}
      {:error, changeset} -> {:noreply, socket |> assign(user_changeset: changeset)}
    end
  end

  def handle_event("choose_category", %{"category" => category}, socket) do
    categories = socket.assigns.categories
    question_position = categories[category]
    categories = increment_position(categories, category, question_position)

    {:noreply,
     socket
     |> assign(
       category: category,
       categories: categories,
       qna: QnA.question(category, question_position)
     )}
  end

  def handle_event("skip-question", _, socket) do
    {:noreply, assign(socket, category: nil)}
  end

  def handle_event("unpause", _, socket) do
    {:noreply, socket |> assign(state: :playing, modal: false)}
  end

  def handle_event("endgame", _, socket) do
    {:noreply, socket |> assign(state: :game_over, modal: false) |> maybe_save_game_record()}
  end

  def handle_event("keydown", %{"key" => "ArrowLeft"}, socket) do
    {:noreply, move(:left, socket)}
  end

  def handle_event("keydown", %{"key" => "ArrowRight"}, socket) do
    {:noreply, move(:right, socket)}
  end

  def handle_event("keydown", %{"key" => "ArrowUp"}, socket) do
    {:noreply, move(:turn, socket)}
  end

  def handle_event("keydown", %{"key" => "ArrowDown"}, socket) do
    {:noreply, drop(socket.assigns.state, socket, true)}
  end

  def handle_event("keydown", %{"key" => " "}, socket) do
    {:noreply, pause_game(socket)}
  end

  def handle_event("keydown", _, socket), do: {:noreply, socket}

  def handle_event("choose_contest", _, socket) do
    {:noreply, socket |> assign(choosing_contest: true)}
  end

  def handle_event("start", %{"contest" => contest_id}, socket) do
    contest_id =
      case Integer.parse(contest_id) do
        {id, _} -> id
        :error -> nil
      end

    contest = if contest_id, do: Contests.get_contest(contest_id)

    {:noreply, socket |> new_game() |> assign(contest_id: contest_id, contest: contest)}
  end

  def handle_event("check_answer", %{"quiz" => %{"guess" => guess}}, socket) do
    socket =
      if correct_answer?(socket.assigns.qna, guess) do
        socket
        |> assign(category: nil)
        |> add_power()
        |> assign(correct_answers: socket.assigns.correct_answers + 1)
        |> assign_score()
      else
        points = wrong_points(socket)
        score = socket.assigns.score - points
        score = if score < 0, do: 0, else: score
        bottom_with_vuln = Bottom.add_vulnerability(socket.assigns.bottom)
        assign(socket, score: score, bottom: bottom_with_vuln)
      end

    {:noreply, socket}
  end

  def handle_event("check_answer", _params, socket), do: {:noreply, socket}

  def handle_event("powerup", %{"powerup" => "moveblock"}, socket) do
    {:noreply, socket |> assign(modal: false, moving_block: true)}
  end

  def handle_event("powerup", %{"powerup" => "addblock"}, socket) do
    {:noreply, socket |> assign(adding_block: true, modal: false)}
  end

  def handle_event("powerup", %{"powerup" => "deleteblock"}, socket) do
    {:noreply, socket |> assign(deleting_block: true, modal: false)}
  end

  def handle_event("powerup", %{"powerup" => "clearblocks"}, socket) do
    powers = socket.assigns.powers -- [:clearblocks]
    {:noreply, socket |> assign(bottom: %{}, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "speedup"}, socket) do
    powers = socket.assigns.powers -- [:speedup]
    speed = Speed.increase_speed(socket.assigns.speed)
    tick_count = Speed.speed_tick_count(speed)

    {:noreply,
     socket
     |> assign(speed: speed)
     |> assign(tick_count: tick_count)
     |> assign(powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "slowdown"}, socket) do
    powers = socket.assigns.powers -- [:slowdown]
    speed = Speed.decrease_speed(socket.assigns.speed)
    tick_count = Speed.speed_tick_count(speed)

    {:noreply,
     socket
     |> assign(speed: speed)
     |> assign(tick_count: tick_count)
     |> assign(powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "fixvuln"}, socket) do
    ## more to do?
    powers = socket.assigns.powers -- [:fixvuln]
    {:noreply, socket |> assign(modal: false, powers: powers, fix_vuln_or_license: true)}
  end

  def handle_event("powerup", %{"powerup" => "fixlicense"}, socket) do
    ## more to do?
    powers = socket.assigns.powers -- [:fixlicense]
    {:noreply, socket |> assign(modal: false, powers: powers, fix_vuln_or_license: true)}
  end

  def handle_event("powerup", %{"powerup" => "rm_all_vulns"}, socket) do
    powers = socket.assigns.powers -- [:rm_all_vulns]
    bottom = Bottom.remove_all_vulnerabilities(socket.assigns.bottom)

    {:noreply,
     socket
     |> assign(powers: powers)
     |> assign(bottom: bottom)}
  end

  def handle_event("powerup", %{"powerup" => "rm_all_lic_issues"}, socket) do
    powers = socket.assigns.powers -- [:rm_all_lic_issues]
    bottom = Bottom.remove_all_license_issues(socket.assigns.bottom)

    {:noreply,
     socket
     |> assign(powers: powers)
     |> assign(bottom: bottom)}
  end

  def handle_event("powerup", %{"powerup" => "superpower"}, socket) do
    # switch to superpower modal to select which power to assign
    powers = socket.assigns.powers -- [:superpower]

    {:noreply,
     socket
     |> assign(state: :paused)
     |> assign(super_modal: true)
     |> assign(modal: false)
     |> assign(powers: powers)}
  end

  def handle_event("powerup", _, socket) do
    {:noreply, socket}
  end

  def handle_event(
        "transform_block",
        %{"x" => x, "y" => y, "color" => color},
        %{assigns: %{moving_block: true}} = socket
      ) do
    {x, y} = parse_to_integer(x, y)
    color = String.to_atom(color)
    {:noreply, socket |> assign(block_coordinates: {x, y, color}, adding_block: true)}
  end

  def handle_event(
        "transform_block",
        %{"x" => x, "y" => y},
        %{assigns: %{deleting_block: true}} = socket
      ) do
    {:noreply, delete_block(socket, x, y)}
  end

  def handle_event(
        "transform_block",
        %{"x" => x, "y" => y, "color" => color},
        %{assigns: %{fix_vuln_or_license: true}} = socket
      ) do
    {x, y} = parse_to_integer(x, y)
    color = String.to_atom(color)
    bottom = Bottom.remove_vuln_and_license(socket.assigns.bottom, {x, y, color})
    {:noreply, socket |> assign(bottom: bottom)}
  end

  def handle_event("transform_block", _params, socket) do
    {:noreply, socket}
  end

  def handle_event(
        "add_block",
        %{"x" => x, "y" => y},
        %{assigns: %{block_coordinates: nil}} = socket
      ) do
    {:noreply, add_block(socket, x, y, socket.assigns.adding_block)}
  end

  def handle_event(
        "add_block",
        %{"x" => x, "y" => y},
        %{assigns: %{block_coordinates: block_coordinates}} = socket
      ) do
    {:noreply,
     socket
     |> move_block(
       x,
       y,
       block_coordinates,
       socket.assigns.adding_block,
       socket.assigns.moving_block
     )}
  end

  def handle_event("super_to_power", %{"spower" => "addblock"}, socket) do
    super_helper(socket, :addblock)
  end

  def handle_event("super_to_power", %{"spower" => "deleteblock"}, socket) do
    super_helper(socket, :deleteblock)
  end

  def handle_event("super_to_power", %{"spower" => "moveblock"}, socket) do
    super_helper(socket, :moveblock)
  end

  def handle_event("super_to_power", %{"spower" => "clearblocks"}, socket) do
    super_helper(socket, :clearblocks)
  end

  def handle_event("super_to_power", %{"spower" => "speedup"}, socket) do
    super_helper(socket, :speedup)
  end

  def handle_event("super_to_power", %{"spower" => "slowdown"}, socket) do
    super_helper(socket, :slowdown)
  end

  def handle_event("super_to_power", %{"spower" => "fixvuln"}, socket) do
    super_helper(socket, :fixvuln)
  end

  def handle_event("super_to_power", %{"spower" => "fixlicense"}, socket) do
    super_helper(socket, :fixlicense)
  end

  def handle_event("super_to_power", %{"spower" => "rm_all_vulns"}, socket) do
    super_helper(socket, :rm_all_vulns)
  end

  def handle_event("super_to_power", %{"spower" => "rm_all_lic_issues"}, socket) do
    super_helper(socket, :rm_all_lic_issues)
  end

  def handle_event("super_to_power", _, socket) do
    {:noreply, socket}
  end

  defp super_helper(socket, power) do
    powers = socket.assigns.powers ++ [power]

    {:noreply,
     socket
     |> assign(super_modal: false)
     |> assign(modal: true)
     |> assign(powers: powers)}
  end

  defp move_block(socket, x, y, block_coordinates, true = _adding_block, true = _moving_block) do
    # check if the coordinates are part of bottom, if they're not return the socket, if they're apply transformation
    # and return socket

    ycoordinate =
      socket.assigns.bottom
      |> Map.keys()
      |> Enum.map(fn value -> elem(value, 1) end)
      |> Enum.map(fn c -> Integer.to_string(c) end)

    if y in ycoordinate do
      {x, y} = parse_to_integer(x, y)
      {x1, y1, color} = block_coordinates

      bottom =
        socket.assigns.bottom
        |> Map.delete({x1, y1})
        |> Map.merge(%{{x, y} => {x, y, color}})

      powers = socket.assigns.powers -- [:moveblock]

      assign(socket,
        bottom: bottom,
        powers: powers,
        adding_block: false,
        moving_block: false
      )
    else
      assign(socket, moving_block: false, adding_block: false)
    end
  end

  defp move_block(socket, _x, _y, _block_coordinates, _adding_block, _moving_block) do
    socket
  end

  defp delete_block(socket, x, y) do
    bottom = socket.assigns.bottom |> Map.delete(parse_to_integer(x, y))
    powers = socket.assigns.powers -- [:deleteblock]
    socket |> assign(bottom: bottom, deleting_block: false, powers: powers)
  end

  defp add_block(socket, x, y, true = _adding_block) do
    {x, y} = parse_to_integer(x, y)
    powers = socket.assigns.powers -- [:addblock]
    bottom = socket.assigns.bottom |> Map.merge(%{{x, y} => {x, y, :purple}})
    socket |> assign(bottom: bottom, adding_block: false, powers: powers)
  end

  defp add_block(socket, _x, _y, false = _adding_block) do
    socket
  end

  defp parse_to_integer(x, y) do
    x = String.to_integer(x)
    y = String.to_integer(y)
    {x, y}
  end

  def handle_info(:tick, socket) do
    {:noreply, on_tick(socket.assigns.state, socket)}
  end

  defp on_tick(:playing, socket) do
    tick_count = socket.assigns.tick_count - 1

    if tick_count > 0 do
      ## don't drop yet
      assign(socket, tick_count: tick_count)
    else
      ## reset counter and drop
      tick_count = Speed.speed_tick_count(socket.assigns.speed)

      ## check vuln Debt
      {tech_vuln_debt, add_vuln?} =
        Threshold.reached_threshold(
          socket.assigns.tech_vuln_debt,
          socket.assigns.vuln_threshold
        )

      ## if reached threshold, add vulnerability
      bottom =
        if add_vuln? do
          Bottom.add_vulnerability(socket.assigns.bottom)
        else
          socket.assigns.bottom
        end

      ## check lic debt
      {tech_lic_debt, add_lic?} =
        Threshold.reached_threshold(
          socket.assigns.tech_lic_debt,
          socket.assigns.lic_threshold
        )

      ## if reached lic debt threshold, add licensing errors
      bottom =
        if add_lic? do
          Bottom.add_license_issue(bottom)
        else
          bottom
        end

      ## see if other bad things happening
      under_attack? = Bottom.attacked?(bottom, socket.assigns.attack_threshold)
      being_sued? = Bottom.sued?(bottom, socket.assigns.lawsuit_threshold)

      {bottom, speed, score} =
        Threshold.bad_happen(
          bottom,
          socket.assigns.speed,
          socket.assigns.score,
          under_attack?,
          being_sued?
        )

      socket =
        assign(socket,
          tick_count: tick_count,
          bottom: bottom,
          tech_vuln_debt: tech_vuln_debt,
          tech_lic_debt: tech_lic_debt,
          score: score,
          speed: speed
        )

      drop(socket.assigns.state, socket, false)
    end
  end

  defp on_tick(_state, socket) do
    socket
  end

  defp correct_answer?(%{correct: guess}, guess), do: true

  defp correct_answer?(%{correct: correct}, guess) do
    guess = String.trim(guess)
    correct == guess
  end

  defp wrong_points(socket) do
    %{"Wrong" => points} = socket.assigns.qna.score
    {points, _} = Integer.parse(points)
    points
  end

  defp right_points(socket) do
    %{"Right" => points} = socket.assigns.qna.score
    {points, _} = Integer.parse(points)
    points
  end

  def debug(assigns), do: debug(assigns, @debug, Mix.env())

  def debug(assigns, true, :dev) do
    ~L"""
    <pre>
    <%= raw( @tetromino |> inspect) %>
    <%= raw( @bottom |> inspect) %>
    </pre>
    """
  end

  def debug(_assigns, _, _), do: ""

  defp init_categories do
    QnA.categories()
    |> Enum.into(%{}, fn elem -> {elem, 0} end)
  end

  defp increment_position(categories, _category, nil), do: categories

  defp increment_position(categories, category, current_position) do
    position =
      if QnA.maximum_category_position(category) == current_position do
        current_position
      else
        current_position + 1
      end

    %{categories | category => position}
  end

  defp assign_score(socket) do
    points = right_points(socket)
    socket |> assign(score: socket.assigns.score + points)
  end

  defp add_power(socket) do
    case socket.assigns.qna[:powerup] do
      nil ->
        socket

      power ->
        current_powers = socket.assigns.powers
        assign(socket, powers: [power | current_powers])
    end
  end

  defp deleting_title({x, y} = _point, true = _deleting_block, true = _block_in_bottom) do
    """
    <title>delete block at {#{x}, #{y}} </title>
    """
  end

  defp deleting_title(_point, _deleting_block, _block_in_bottom), do: ""

  defp moving_title(true = _moving_block, true = _block_in_bottom) do
    """
     <title>click to move block </title>
    """
  end

  defp moving_title(_moving_block, _block_in_bottom), do: ""

  defp block_in_bottom?(nil, _bottom), do: false

  defp block_in_bottom?({x, y, _color} = _coordinates, bottom) do
    block_in_bottom?(x, y, bottom)
  end

  defp block_in_bottom?(x, y, bottom) do
    Map.has_key?(bottom, {x, y})
  end
end
