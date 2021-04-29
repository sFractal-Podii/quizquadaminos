defmodule QuadquizaminosWeb.PageView do
  use QuadquizaminosWeb, :view
  alias Quadquizaminos.Accounts

  def display_name_and_avatar("anonymous" = _current_user), do: ""

  def display_name_and_avatar(current_user) do
    ~E"""
     <h2>Welcome, <%= current_user.name %>!</h2>
     <div>
       <img src="<%= current_user.avatar %>" />
     </div>
    """
  end

  def hide_or_show_sign_up_link do
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
    <a class="button" href="<%= Routes.auth_path(QuadquizaminosWeb.Endpoint, :request, "github") %>">
         <i class="fas fa-github"></i>
         Sign in with GitHub
       </a>
    <a class = "button" href="<%= Routes.auth_path(QuadquizaminosWeb.Endpoint, :request, "google") %>">
        Sign in with Google
        </a>
    """
  end

  defp sign_up_button("anonymous_login") do
    ~E"""
    <a class="button" href="<%= Routes.auth_path(QuadquizaminosWeb.Endpoint, :request, "github") %>">
         <i class="fas fa-github"></i>
         Sign in with GitHub
       </a>
    <a class = "button" href="<%= Routes.auth_path(QuadquizaminosWeb.Endpoint, :request, "google") %>">
        Sign in with Google
        </a>
    <a class="button" href="<%= Routes.page_path(QuadquizaminosWeb.Endpoint, :anonymous )%>" >
          Sign in anonymously
        </a>
    """
  end

  defp sign_up_button(_) do
    ""
  end

  defp selected_login_level do
    Accounts.get_selected_login_level().name
  end
end
