defmodule QuadquizaminosWeb.TetrisLive do
  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]

  import QuadquizaminosWeb.LiveHelpers
  import QuadquizaminosWeb.Instructions
  alias QuadquizaminosWeb.SvgBoard
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  alias Quadquizaminos.{
    Bottom,
    Brick,
    Hints,
    Points,
    Powers,
    Presets,
    QnA,
    Speed,
    Tetris,
    Threshold
  }

  alias Quadquizaminos.GameBoard.Records

  @debug false
  @box_width 20
  @box_height 20

  def mount(_param, %{"uid" => current_user}, socket) do
    :timer.send_interval(50, self(), :tick)
    :timer.send_interval(10_000, self(), :broadcast_score)
    QuadquizaminosWeb.Endpoint.subscribe("contest_timer")

    {:ok,
     socket
     |> assign(current_user: current_user, start_timer: false)
     |> init_game
     |> start_game()}
  end

  def render(%{state: :starting, live_action: live_action} = assigns) do
    ~L"""
    <%= if live_action == :instructions do %>
    <div class = "phx-modal-content">
        <%= raw game_instruction() %>
      </div>
      <% else %>
        <div class ="container">
          <div class="row">
              <div class="column column-50 column-offset-25">
                <h1>Welcome to QuadBlockQuiz!</h1>
                  <button phx-click="start">Start</button>
              </div>
          </div>
        </div>
    <% end %>
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
              <button phx-click="start">Play again?</button>
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
                <%= live_modal @socket,  QuadquizaminosWeb.QuizModalComponent, id: 1, powers: @powers, score: @score,  modal: @modal, qna: @qna, category: @category, return_to: Routes.tetris_path(QuadquizaminosWeb.Endpoint, :tetris)%>
                <% end %>
                <%= if @instructions_modal do %>
                 <%= live_modal @socket, QuadquizaminosWeb.InstructionsComponent, id: 2, return_to: Routes.tetris_path(QuadquizaminosWeb.Endpoint, :tetris) %>
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
            <a class="button" phx-click="instructions">  How to play </a>
            <%= raw Hints.tldr(@hint) %>
            </div>
          <br/>
        </div>
    </div>
    <%= debug(assigns) %>
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

  ## raise_speed gets removed once dev cheat gets removed
  defp raise_speed(socket) do
    speed = Speed.increase_speed(socket.assigns.speed)
    tick_count = Speed.speed_tick_count(speed)
    assign(socket, speed: speed, tick_count: tick_count)
  end

  ## lower_speed gets removed once dev cheat gets removed
  defp lower_speed(socket) do
    speed = Speed.decrease_speed(socket.assigns.speed)
    tick_count = Speed.speed_tick_count(speed)
    assign(socket, speed: speed, tick_count: tick_count)
  end

  ## clear_blocks gets removed once dev cheat gets removed
  defp clear_blocks(socket) do
    assign(socket, bottom: %{})
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
    |> assign(instructions_modal: false)
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

    %{
      start_time: socket.assigns.start_time,
      end_time: DateTime.utc_now(),
      uid: socket.assigns.current_user,
      score: socket.assigns.score,
      dropped_bricks: socket.assigns.brick_count,
      bottom_blocks: bottom_block,
      correctly_answered_qna: socket.assigns.correct_answers
    }
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

    Records.record_player_game(response.game_over, game_record(socket))

    socket
    |> assign(brick: response.brick)
    |> assign(bottom: response.bottom)
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
        if(response.game_over,
          do: :game_over,
          else: :playing
        )
    )
    |> show
  end

  def drop(_not_playing, socket, _fast), do: socket

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

  def handle_event("unpause", _, socket) do
    {:noreply, socket |> assign(state: :playing, modal: false)}
  end

  def handle_event("endgame", _, socket) do
    Records.record_player_game(true, game_record(socket))
    {:noreply, socket |> assign(state: :game_over, modal: false)}
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

  def handle_event("start", _, socket) do
    {:noreply, new_game(socket)}
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

  def handle_event("instructions", _params, socket) do
    {:noreply, socket |> assign(instructions_modal: true, state: :paused)}
  end

  def handle_event("close_instructions", _param, socket) do
    {:noreply, socket |> assign(instructions_modal: false, state: :playing)}
  end

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

  defp block_in_bottom?(x, y, bottom) do
    Map.has_key?(bottom, {x, y})
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

  def handle_info(:broadcast_score, socket) do
    QuadquizaminosWeb.Endpoint.broadcast(
      "scores",
      "current_score",
      game_record(socket) |> Map.delete(:end_time)
    )

    {:noreply, socket}
  end

  def handle_info(%{event: "timer", payload: _payload}, socket) do
    if socket.assigns.state == :playing do
      Records.record_player_game(true, game_record(socket))
    end

    {:noreply, socket |> assign(state: :game_over)}
  end

  def handle_info(:tick, socket) do
    {:noreply, on_tick(socket.assigns.state, socket)}
  end

  defp on_tick(:game_over, socket) do
    QuadquizaminosWeb.Endpoint.broadcast(
      "scores",
      "current_score",
      game_record(socket)
    )

    socket
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
    ## if not in playing state, don't do anything on tick
    socket
  end

  defp correct_answer?(%{correct: guess}, guess), do: true
  defp correct_answer?(_qna, _guess), do: false

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

  defp increment_position(categories, category, current_position) do
    %{categories | category => current_position + 1}
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

  defp block_in_bottom?({x, y, _color} = _coordinates, bottom) do
    block_in_bottom?(x, y, bottom)
  end
end
