defmodule QuadquizaminosWeb.TetrisLive do
  use Phoenix.LiveView
  import Phoenix.HTML, only: [raw: 1]

  alias Quadquizaminos.Tetris

  @debug false

  def mount(_param, _session, socket) do
    :timer.send_interval(250, self(), :tick)
    {:ok, start_game(socket)}
  end

  def render(%{state: :playing} = assigns) do
    ~L"""

      <div class="container">
        <div class="row">
          <div class="column column-75">
              <div class="row">
                <div class="column column-25 column-offset-25">
                    <h1><%= @score %></h1>
                </div>
                <div class="column column-50"> 
                  <div phx-window-keydown="keydown">
                    <%= raw svg_head() %>
                    <%= for row <- [@tetromino, Map.values(@bottom)] do %> 
                      <%= for {x, y, color} <- row do %>
                        <% {x, y} = to_pixels( {x, y}, @box_width, @box_height ) %> 
                        <rect 
                          x="<%= x+1 %>" y="<%= y+1 %>" 
                          style="fill:#<%= shades(color).light %>;" 
                          width="<%= @box_width - 2 %>" height="<%= @box_height - 1 %>"/>
                        <%= end %>
                    <%= end %>
                    <%= raw svg_foot() %>
                  </div>  
                </div>
              </div>
            </div> 
           <div class="column"> 
              <h2>How to play</h2>
                <ol>
                  <li>Up arrow key rotates the blocks</li>
                  <li>Left arrow key moves the blocks to the left</li>
                  <li>Right arrow key moves the blocks to the right</li>
                </ol>
           </div>
          <%= debug(assigns) %>
        </div>
    </div>
    """
  end

  def render(%{state: :starting} = assigns) do
    ~L"""
    <div class ="container">
      <div class="row">
          <div class="column column-50 column-offset-25"> 
            <h1>Welcome to Tetris!</h1>
              <button phx-click="start">Start</button>
                <h2>How to play</h2>
                  <ol>
                    <li>Up arrow key rotates the blocks</li>
                    <li>Left arrow key moves the blocks to the left</li>
                    <li>Right arrow key moves the blocks to the right</li>
                </ol>
           </div>
      </div>
    </div>
    """
  end

  def render(%{state: :game_over} = assigns) do
    ~L"""
    <div class="container">
      <h1>Game Over</h1>
      </div>
       <div class="container">
      <h2>Your score: <%= @score %></h2>
       </div>
        <div class="container">
      <button phx-click="start">Play again?</button>
      </div>
      <%= debug(assigns) %>
     
    """
  end

  defp start_game(socket) do
    assign(socket,
      state: :starting,
      box_width: 20,
      box_height: 20
    )
  end

  defp new_game(socket) do
    assign(socket,
      state: :playing,
      score: 0,
      bottom: %{}
    )
    |> new_block
    |> show
  end

  def new_block(socket) do
    brick =
      Quadquizaminos.Brick.new_random()
      |> Map.put(:location, {3, -3})

    assign(socket, brick: brick)
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
    xml:space="preserve">
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

  def box(point, color) do
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

    socket
    |> assign(
      brick: response.brick,
      bottom: response.bottom,
      score: socket.assigns.score + response.score + bonus,
      state: if(response.game_over, do: :game_over, else: :playing)
    )
    |> show
  end

  def drop(_not_playing, socket, _fast), do: socket

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

  def do_move(%{assigns: %{brick: brick, bottom: bottom}} = socket, :turn) do
    assign(socket, brick: socket.assigns.brick |> Tetris.try_spin_90(bottom))
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

  def handle_event("keydown", _, socket), do: {:noreply, socket}

  def handle_event("start", _, socket) do
    {:noreply, new_game(socket)}
  end

  def handle_info(:tick, socket) do
    {:noreply, drop(socket.assigns.state, socket, false)}
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

  def debug(assigns, _, _), do: ""
end
