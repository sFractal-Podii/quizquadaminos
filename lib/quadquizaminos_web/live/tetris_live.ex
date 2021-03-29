defmodule QuadquizaminosWeb.TetrisLive do
  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]

  import QuadquizaminosWeb.LiveHelpers
  alias QuadquizaminosWeb.Router.Helpers, as: Routes
  alias Quadquizaminos.QnA

  alias Quadquizaminos.Tetris

  @debug false
  @box_width 20
  @box_height 20

  # 20/s, 50 ms
  @drop_speeds [
    %{name: "full throttle", ratio: 1},
    # 10/s, 100 ms
    %{name: "high speed", ratio: 2},
    # 4/s, 250 ms. - default game starts with
    %{name: "fast", ratio: 5},
    # ~3/s, 350 ms
    %{name: "moderate", ratio: 7},
    # 2/s, 500 ms
    %{name: "leisurely", ratio: 10},
    # 3/2s, 750 ms
    %{name: "sedate", ratio: 15},
    # 1/s, 1000 ms
    %{name: "lethargic", ratio: 20}
  ]

  def mount(_param, _session, socket) do
    :timer.send_interval(50, self(), :tick)

    {:ok,
     socket
     |> assign(qna: %{}, powers: [])
     |> assign(category: nil, categories: init_categories())
     |> assign(block_coordinates: nil)
     |> assign(adding_block: false, moving_block: false, deleting_block: false)
     |> assign(instructions_modal: false)
     |> assign(speed: 2, tick_count: 5)
     |> assign(brick_count: 0)
     |> assign(row_count: 0)
     |> assign(correct_answers: 0)
     |> start_game()}
  end

  def render(%{state: :starting, live_action: live_action} = assigns) do
    ~L"""
    <%= if live_action == :instructions do %>
    <div class = "phx-modal-content">
        <%= raw QuadquizaminosWeb.Instructions.game_instruction() %>
      </div>
      <% else %>
        <div class ="container">
          <div class="row">
              <div class="column column-50 column-offset-25">
                <h1>Welcome to QuizQuadBlocks!</h1>
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
            This section To Be Implemented (TBI).
            You are bankrupt because either
            due to a cyberattack or a lawsuit.
            This may be because you let your supply chain get to long.
            Or may be due to unfixed vulnerabilities were turned into exploits.
            Or uncleared licensing errors caused you to be sued.
            Or maybe you were too busy answering cybersecurity questions
            and not paying attention to business.
            Future editions will tell you which it was, and give
            more info in addition to the score
            (quadblocks dropped, rows cleared,
            questions answered, ...)
              <hr>
              <button phx-click="start">Play again?</button>
        </div>
      </div>
    </div>
     <%= debug(assigns) %>

    """
  end

  def render(assigns) do
    ~L"""
      <div class="container" >
        <div class="row">
          <div class="column column-75">
              <div class="row">
                <div class="column column-25 column-offset-25">
                    <h1><%= @score %></h1>
                    <h2>Score</h2>
                    <hr>
                    <%= @brick_count %>
                    QuadBlocks
                    <hr>
                    <h4><%= @row_count %></h4>
                    <h4>Rows</h4>
                    <hr>
                    <h5><%= @correct_answers %></h5>
                    <h5>Answers</h5>
                    <hr>
                </div>
                <div class="column column-50">
                <%= if @modal do %>
                <%= live_modal @socket,  QuadquizaminosWeb.QuizModalComponent, id: 1, powers: @powers, score: @score,  modal: @modal, qna: @qna, category: @category, return_to: Routes.tetris_path(QuadquizaminosWeb.Endpoint, :tetris)%>
                <% end %>
                <%= if @instructions_modal do %>
                 <%= live_modal @socket, QuadquizaminosWeb.InstructionsComponent, id: 2, return_to: Routes.tetris_path(QuadquizaminosWeb.Endpoint, :tetris) %>
                <% end %>
                  <div phx-window-keydown="keydown" class="grid">
                    <%= raw svg_head() %>
                    <%= for x1 <- 1..10, y1 <- 1..20 do %>
                    <% {x, y} = to_pixels( {x1, y1}, @box_width, @box_height ) %>
                    <rect phx-click="add_block" phx-value-x=<%= x1 %> phx-value-y=<%= y1 %>
                    x="<%= x + 1 %>" y="<%= y + 1 %>"
                    class="position-block <%= if @adding_block, do: "hover-block" %>"
                    width="<%= @box_width - 2 %>" height="<%= @box_height - 1 %>"/>
                    <% end %>

                    <%= for row <- [@tetromino, Map.values(@bottom)] do %>
                      <%= for {x, y, color} <- row do %>
                      <svg phx-click="move_or_delete_block" phx-value-x= <%= x %> phx-value-y=<%= y %> phx-value-color= <%= color %>>
                       <%= raw box({x, y}, color)%>
                          <%= raw deleting_title({x, y}, @deleting_block, block_in_bottom?(x, y, @bottom)) %>
                           <%= raw moving_title(@moving_block, block_in_bottom?(x, y, @bottom))  %>
                       </svg>
                        <% end %>
                    <% end %>

                    <%= raw svg_foot() %>
                  </div>
                </div>
              </div>
            </div>
            <div class="column">
            <a class="button" phx-click="instructions">  How to play </a>
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
    |> assign(state: :playing)
    |> assign(score: 0)
    |> assign(bottom: %{})
    |> assign(powers: [])
    |> assign(speed: 2)
    |> assign(tick_count: 5)
    |> assign(brick_count: 0)
    |> assign(row_count: 0)
    |> assign(correct_answers: 0)
    |> new_block
    |> show

  end

  ## raise_speed gets removed once dev cheat gets removed
  defp raise_speed(socket) do
    speed = socket.assigns.speed - 1
    speed = if speed < 0, do: 0, else: speed
    {:ok, speed_info} = Enum.fetch(@drop_speeds, speed)
    tick_count = speed_info.ratio
    assign(socket, speed: speed, tick_count: tick_count)
  end

  ## lower_speed gets removed once dev cheat gets removed
  defp lower_speed(socket) do
    speed = socket.assigns.speed + 1
    lowest_speed = length(@drop_speeds) - 1
    speed = if speed > lowest_speed, do: lowest_speed, else: speed
    {:ok, speed_info} = Enum.fetch(@drop_speeds, speed)
    tick_count = speed_info.ratio
    assign(socket, speed: speed, tick_count: tick_count)
  end

  ## clear_blocks gets removed once dev cheat gets removed
  defp clear_blocks(socket) do
    assign(socket, bottom: %{})
  end

  def new_block(socket) do
    brick_count = socket.assigns.brick_count + 1
    brick = Quadquizaminos.Brick.new_random()
    assign(socket, brick: brick, brick_count: brick_count)
  end

  def show(socket) do
    brick = socket.assigns.brick

    points =
      brick
      |> Quadquizaminos.Brick.prepare()
      |> Quadquizaminos.Points.move_to_location(brick.location)
      |> Quadquizaminos.Points.with_color(color(brick))

    assign(socket, tetromino: points)
  end

  def svg_head() do
    """
    <svg
    version="1.0"
    style="background-color: #F8F8F8"
    id="Layer_1"
    xmlns="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    width="200" height="400"
    viewBox="0 0 200 400"
    xml:space="preserve"
    aria-labelledby="title">
    """
  end

  def svg_foot(), do: "</svg>"

  def boxes(points_with_colors) do
    points_with_colors
    |> Enum.map(fn {x, y, color} ->
      box({x, y}, color)
    end)
    |> Enum.join("\n")
  end

  def box({_x, _y} = point, color) do
    """
    #{square(point, shades(color).light)}
    #{triangle(point, shades(color).dark)}
    """
  end

  def square(point, shade) do
    {x, y} = to_pixels(point, 20, 20)

    """
    <rect
      x="#{x + 1}" y="#{y + 1}"
      style="fill:##{shade};"
      width="#{@box_width - 2}" height="#{@box_height - 1}"/>
    """
  end

  def triangle(point, shade) do
    {x, y} = to_pixels(point, 20, 20)
    {w, h} = {@box_width, @box_height}

    """
    <polyline
        style="fill:##{shade}"
        points="#{x + 1},#{y + 1} #{x + w},#{y + 1} #{x + w},#{y + h}" />
    """
  end

  defp to_pixels({x, y}, bw, bh), do: {(x - 1) * bw, (y - 1) * bh}

  defp shades(:red), do: %{light: "DB7160", dark: "AB574B"}
  defp shades(:blue), do: %{light: "83C1C8", dark: "66969C"}
  defp shades(:green), do: %{light: "8BBF57", dark: "769359"}
  defp shades(:orange), do: %{light: "CB8E4E", dark: "AC7842"}
  defp shades(:grey), do: %{light: "A1A09E", dark: "7F7F7E"}
  defp shades(:purple), do: %{light: "800080", dark: "4d004d"}

  defp color(%{name: :t}), do: :red
  defp color(%{name: :i}), do: :blue
  defp color(%{name: :l}), do: :green
  defp color(%{name: :o}), do: :orange
  defp color(%{name: :z}), do: :grey

  def drop(:playing, socket, fast) do
    old_brick = socket.assigns.brick

    response =
      Tetris.drop(
        old_brick,
        socket.assigns.bottom,
        color(old_brick)
      )

    bonus = if fast, do: 2, else: 0
    row_count = socket.assigns.row_count + response.row_count
    score = socket.assigns.score + response.score + bonus

    socket
    |> assign(
      brick: response.brick,
      bottom: response.bottom,
      row_count: row_count,
      score: score,
      state: if(response.game_over, do: :game_over, else: :playing)
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

  ## until powerups and for debugging - take out eventually
  def handle_event("keydown", %{"key" => "l"}, socket) do
    {:noreply, lower_speed(socket)}
  end

  ## until powerups and for debugging - take out eventually
  def handle_event("keydown", %{"key" => "r"}, socket) do
    {:noreply, raise_speed(socket)}
  end

  ## until powerups and for debugging - take out eventually
  def handle_event("keydown", %{"key" => "c"}, socket) do
    {:noreply, clear_blocks(socket)}
  end

  ## until powerups and for debugging - take out eventually
  def handle_event("keydown", %{"key" => "p"}, socket) do
    powers = socket.assigns.powers ++
              Quadquizaminos.Powers.all_powers()
              |> Enum.sort
    {:noreply, socket |> assign(powers: powers)}
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
        socket = assign(socket, score: score)
        pause_game(socket)
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
    speed = socket.assigns.speed - 1
    speed = if speed < 0, do: 0, else: speed
    {:ok, speed_info} = Enum.fetch(@drop_speeds, speed)
    tick_count = speed_info.ratio
    {:noreply, assign(socket, speed: speed, tick_count: tick_count, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "slowdown"}, socket) do
    powers = socket.assigns.powers -- [:slowdown]
    speed = socket.assigns.speed + 1
    lowest_speed = length(@drop_speeds) - 1
    speed = if speed > lowest_speed, do: lowest_speed, else: speed
    {:ok, speed_info} = Enum.fetch(@drop_speeds, speed)
    tick_count = speed_info.ratio
    {:noreply, assign(socket, speed: speed, tick_count: tick_count, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "nextblock"}, socket) do
    powers = socket.assigns.powers -- [:nextblock]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "forensics"}, socket) do
    powers = socket.assigns.powers -- [:forensics]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "slowvulns"}, socket) do
    powers = socket.assigns.powers -- [:slowvulns]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "slowlicense"}, socket) do
    powers = socket.assigns.powers -- [:slowlicense]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "legal"}, socket) do
    powers = socket.assigns.powers -- [:legal]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "insurance"}, socket) do
    powers = socket.assigns.powers -- [:insurance]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "sbom"}, socket) do
    powers = socket.assigns.powers -- [:sbom]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "fixvuln"}, socket) do
    powers = socket.assigns.powers -- [:fixvuln]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "fixlicense"}, socket) do
    powers = socket.assigns.powers -- [:fixlicense]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "fixallvulns"}, socket) do
    powers = socket.assigns.powers -- [:fixallvulns]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "fixalllicenses"}, socket) do
    powers = socket.assigns.powers -- [:fixalllicenses]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "automation"}, socket) do
    powers = socket.assigns.powers -- [:automation]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "openchain"}, socket) do
    powers = socket.assigns.powers -- [:openchain]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "stopattack"}, socket) do
    powers = socket.assigns.powers -- [:stopattack]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "winlawsuit"}, socket) do
    powers = socket.assigns.powers -- [:winlawsuit]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", %{"powerup" => "superpower"}, socket) do
    powers = socket.assigns.powers -- [:superpower]
    {:noreply, assign(socket, powers: powers)}
  end

  def handle_event("powerup", _, socket) do
    {:noreply, socket}
  end

  def handle_event(
        "move_or_delete_block",
        %{"x" => x, "y" => y, "color" => color},
        %{assigns: %{moving_block: true}} = socket
      ) do
    {x, y} = parse_to_integer(x, y)
    color = String.to_atom(color)
    {:noreply, socket |> assign(block_coordinates: {x, y, color}, adding_block: true)}
  end

  def handle_event(
        "move_or_delete_block",
        %{"x" => x, "y" => y},
        %{assigns: %{deleting_block: true}} = socket
      ) do
    {:noreply, delete_block(socket, x, y)}
  end

  def handle_event("move_or_delete_block", _params, socket) do
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

  defp move_block(socket, x, y, block_coordinates, true = _adding_block, true = _moving_block) do
    {x, y} = parse_to_integer(x, y)
    {x1, y1, color} = block_coordinates
    powers = socket.assigns.powers -- [:moveblock]

    bottom =
      socket.assigns.bottom |> Map.delete({x1, y1}) |> Map.merge(%{{x, y} => {x, y, color}})

    assign(socket,
      bottom: bottom,
      powers: powers,
      state: :playing,
      adding_block: false,
      moving_block: false
    )
  end

  defp move_block(socket, _x, _y, _block_coordinates, _adding_block, _moving_block) do
    socket
  end

  defp delete_block(socket, x, y) do
    bottom = socket.assigns.bottom |> Map.delete(parse_to_integer(x, y))
    powers = socket.assigns.powers -- [:deleteblock]
    socket |> assign(bottom: bottom, deleting_block: false, state: :playing, powers: powers)
  end

  defp block_in_bottom?(x, y, bottom) do
    Map.has_key?(bottom, {x, y})
  end

  defp add_block(socket, x, y, true = _adding_block) do
    {x, y} = parse_to_integer(x, y)
    powers = socket.assigns.powers -- [:addblock]
    bottom = socket.assigns.bottom |> Map.merge(%{{x, y} => {x, y, :purple}})
    socket |> assign(bottom: bottom, adding_block: false, state: :playing, powers: powers)
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
    tick_count = socket.assigns.tick_count - 1

    if tick_count > 0 do
      ## don't drop yet
      socket = assign(socket, tick_count: tick_count)
      {:noreply, socket}
    else
      ## reset counter and drop
      {:ok, speed_info} = Enum.fetch(@drop_speeds, socket.assigns.speed)
      tick_count = speed_info.ratio

      socket = assign(socket, tick_count: tick_count)
      {:noreply, drop(socket.assigns.state, socket, false)}
    end
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
end
