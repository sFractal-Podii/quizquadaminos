defmodule QuadquizaminosWeb.PageView do
  use QuadquizaminosWeb, :view
  alias Quadquizaminos.Accounts

  def render("instructions.html", _params) do
    QuadquizaminosWeb.Instructions.game_instruction()
  end

  def render("sbom.html", _params) do
    sbom_files =
      :quadquizaminos
      |> Application.app_dir("/priv/static/.well-known/sbom")
      |> File.ls!()

    ~E"""
    <%= for file <- sbom_files do %>
    <li> <%= link file,  to: [".well-known/sbom/",file] %> </li>
    <% end %>
    """
  end

  def display_name_and_avatar("anonymous" = _current_user), do: ""

  def display_name_and_avatar(current_user) do
    ~E"""
     <h2>Welcome, <%= current_user.name %>!</h2>
     <div>
       <img src="<%= current_user.avatar %>" />
     </div>
    """
  end

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
end
