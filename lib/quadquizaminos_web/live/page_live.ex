defmodule QuadquizaminosWeb.PageLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Quadquizaminos.UserFromAuth
  alias QuadquizaminosWeb.Router.Helpers, as: Routes

  def mount(_param, session, socket) do
    user_id = Map.get(session, "user_id")
    {:ok, socket |> assign(current_user: current_user(user_id))}
  end

  def render(assigns) do
    ~L"""
    <div class="container"> 
    <section class="phx-hero">
    <h1>QuadQuizAminos</h1>
    <%= if @current_user do %>
     <h2>Welcome, <%= @current_user.name %>!</h2>
     <div>
       <img src="<%= @current_user.avatar %>" />
     </div>
     <%= link "Tetris Game", to: Routes.live_path(QuadquizaminosWeb.Endpoint, QuadquizaminosWeb.TetrisLive), class: "button" %>
     <br>
    <% else %>
     <ul style="list-style: none">
       <li>
         <a class="button" href="<%= Routes.auth_path(QuadquizaminosWeb.Endpoint, :request, "github") %>">
           <i class="fa fa-github"></i>
           Sign in with GitHub
         </a>
       </li>
     </ul>
    <% end %>
    </section>
    </div>
    """
  end

  defp current_user(nil), do: nil

  defp current_user(user_id) do
    UserFromAuth.get_user(user_id)
  end
end
