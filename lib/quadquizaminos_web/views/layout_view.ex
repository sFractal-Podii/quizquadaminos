defmodule QuadquizaminosWeb.LayoutView do
  use QuadquizaminosWeb, :view
  alias Quadquizaminos.Accounts

  def hide_or_show_sign_up_button do
    selected_login_level() |> sign_up_button()
  end

  defp sign_up_button("by_config") do
    ~E"""
    <a class="button" href="<%= Routes.auth_path(QuadquizaminosWeb.Endpoint, :request, "github") %>">
        <i class="fas fa-github"></i>
        Sign in with GitHub
      </a>
    """
  end

  defp sign_up_button("oauth_login") do
    ~E"""
      <%= oath_sign_in() %>
    </div>
    </div>
    """
  end

  defp sign_up_button(_login_level) do
    ~E"""
    <%= oath_sign_in() %>
    <a class="button" href="<%= Routes.page_path(QuadquizaminosWeb.Endpoint, :anonymous )%>" >
          Sign in anonymously
        </a>
    </div>
    </div>
    """
  end

  defp oath_sign_in do
    ~E"""
    <div class="dropdown">
    <button class="dropbtn">Sign In</button>
      <div class="dropdown-content">
          <a class="button" href="<%= Routes.auth_path(QuadquizaminosWeb.Endpoint, :request, "github") %>">
          <i class="fas fa-github"></i>
          Sign in with GitHub
          </a>
          <a class = "button" href="<%= Routes.auth_path(QuadquizaminosWeb.Endpoint, :request, "google") %>">
          Sign in with Google
          </a>
          <a class = "button" href="<%= Routes.auth_path(QuadquizaminosWeb.Endpoint, :request, "linkedin") %>">
          Sign in with LinkedIn
          </a>
    """
  end

  defp selected_login_level do
    case Accounts.get_selected_login_level() do
      nil -> nil
      login_level -> login_level.name
    end
  end

  defp admin_dropdown do
    ~E"""
    <div class="dropdown">
    <a href="/admin" class="dropbtn">
    Admin
    <i class="fa fa-caret-down"></i>
    </a>
     <div class="dropdown-content">
     <a class="button" href="<%= Routes.live_path(QuadquizaminosWeb.Endpoint, QuadquizaminosWeb.AdminContestsLive) %>">
     Contest
     </a>
     <a class = "button" href="<%= Routes.live_path(QuadquizaminosWeb.Endpoint, QuadquizaminosWeb.AdminLive) %>">
     Login
     </a>
    """
  end
end
