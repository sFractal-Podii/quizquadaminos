defmodule QuadquizaminosWeb.AdminLive do
  use Phoenix.LiveView
  alias Quadquizaminos.Accounts

  def mount(_param, _session, socket) do
    {:ok,
     socket
     |> assign(
       by_config: selected?("by_config"),
       oauth_login: selected?("oauth_login"),
       anonymous_login: selected?("anonymous_login"),
       login_levels: ["by_config", "oauth_login", "anonymous_login"]
     )}
  end

  def render(assigns) do
    ~L"""
    <div class="container">
    <h1>users level of login</h1>
     <form  phx-change="login_levels">
     <label>
    <input type="radio" id="by_config" name="login_levels" value="by_config" <%= if @by_config, do: 'checked' %>> by_config
    </label>
    <label>
    <input type="radio" id="oauth_login" name="login_levels" value="oauth_login" <%= if @oauth_login, do: 'checked' %>> oauth_login
    </label>
    <label>
    <input type="radio" id="anonymous_login" name="login_levels" value="anonymous_login" <%= if @anonymous_login, do: 'checked' %>>anonymous_login
    </label>
    </form> 
    </div>
    """
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
