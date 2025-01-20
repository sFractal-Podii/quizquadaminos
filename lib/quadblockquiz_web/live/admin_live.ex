defmodule QuadblockquizWeb.AdminLive do
  use QuadblockquizWeb, :live_view
  alias Quadblockquiz.Accounts

  def mount(_param, _session, socket) do
    {:ok,
     socket
     |> assign(
       by_config: selected?("by_config"),
       oauth_login: selected?("oauth_login"),
       anonymous_login: selected?("anonymous_login"),
       login_levels: ["by_config", "oauth_login", "anonymous_login"],
       cleared?: false
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="container">
      <h1>users level of login</h1>
      <section class="phx-hero">
        <h3>{notification(assigns)}</h3>
      </section>
      <form phx-change="login_levels">
        <label>
          <input
            type="radio"
            id="by_config"
            name="login_levels"
            value="by_config"
            checked={@by_config}
          /> by_config
        </label>
        <label>
          <input
            type="radio"
            id="oauth_login"
            name="login_levels"
            value="oauth_login"
            checked={@oauth_login}
          /> oauth_login
        </label>
        <label>
          <input
            type="radio"
            id="anonymous_login"
            name="login_levels"
            value="anonymous_login"
            checked={@anonymous_login}
          />anonymous_login
        </label>
      </form>

      <%= if @cleared? do %>
        <div class="alert-info">
          <p>Game score records have been cleared</p>
        </div>
      <% end %>

      <h2>Reset game table</h2>
      {raw(reset_game_table_button())}
    </div>
    """
  end

  defp reset_game_table_button do
    """
    <button phx-click="reset-game-table" data-confirm="Are you sure you want to reset all scores?">Reset All Scores</button>
    """
  end

  def handle_event("reset-game-table", _, socket) do
    {_count, _} = Quadblockquiz.Repo.delete_all(Quadblockquiz.GameBoard)
    {:noreply, socket |> assign(cleared?: true)}
  end

  def handle_event("login_levels", %{"login_levels" => selected_level}, socket) do
    initially_selected_level = initially_selected_level(selected_level, socket)
    {:noreply, update_login_level(socket, selected_level, initially_selected_level)}
  end

  defp update_login_level(socket, selected_level, initially_selected_level) do
    case Accounts.update_login_level(selected_level, initially_selected_level) do
      {:ok, _} ->
        socket
        |> assign(to_atom(initially_selected_level), false)
        |> assign(to_atom(selected_level), true)

      _ ->
        socket
    end
  end

  defp notification(assigns) do
    ~H"""
    {if @by_config, do: "by_config is active"}
    {if @oauth_login, do: "oauth_login  is active"}
    {if @anonymous_login, do: "anonymous_login is active"}
    """
  end

  defp selected?(level) do
    Accounts.get_login_level(level).active
  end

  defp initially_selected_level(selected_level, socket) do
    [first_level | [second_level]] = socket.assigns.login_levels -- [selected_level]

    case Map.get(socket.assigns, String.to_atom(first_level)) do
      true -> first_level
      _ -> second_level
    end
  end

  defp to_atom(login_level) do
    String.to_atom(login_level)
  end
end
