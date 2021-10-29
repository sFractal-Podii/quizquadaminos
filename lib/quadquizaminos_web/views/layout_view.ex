defmodule QuadquizaminosWeb.LayoutView do
  use QuadquizaminosWeb, :view
  alias Quadquizaminos.Accounts

  @dropdown_item_class "block px-4 py-2 mt-2 text-sm font-semibold bg-transparent dark-mode:bg-transparent dark-mode:hover:bg-gray-600 dark-mode:focus:bg-gray-600 dark-mode:focus:text-white dark-mode:hover:text-white dark-mode:text-gray-200 md:mt-0 hover:text-gray-900 focus:text-gray-900 hover:bg-gray-200 focus:bg-gray-200 focus:outline-none focus:shadow-outline"

  def hide_or_show_sign_up_button(styling \\ :milligram) do
    selected_login_level() |> sign_up_button(styling)
  end

  defp sign_up_button("by_config", style) do
    case style do
      :milligram ->
        ~E"""
          <a class="button" href="<%= Routes.auth_path(QuadquizaminosWeb.Endpoint, :request, "github") %>">
            <i class="fas fa-github"></i>
            Sign in with GitHub
          </a>
        """

      :tailwind ->
        ~E"""
        <a class="block px-4 py-2 mt-2 text-sm font-semibold bg-transparent dark-mode:bg-transparent dark-mode:hover:bg-gray-600 dark-mode:focus:bg-gray-600 dark-mode:focus:text-white dark-mode:hover:text-white dark-mode:text-gray-200 md:mt-0 hover:text-gray-900 focus:text-gray-900 hover:bg-gray-200 focus:bg-gray-200 focus:outline-none focus:shadow-outline"
            href="<%= Routes.auth_path(QuadquizaminosWeb.Endpoint, :request, "github") %>">Github Sign In</a>
        """
    end
  end

  defp sign_up_button("oauth_login", style) do
    case style do
      :milligram ->
        ~E"""
          <%= oath_sign_in() %>
        </div>
        </div>
        """

      :tailwind ->
        ~E"""
          <%= oath_sign_in(:tailwind) %>
        """
    end
  end

  defp sign_up_button(_login_level, style) do
    case style do
      :milligram ->
        ~E"""
        <%= oath_sign_in() %>
        <a class="button" href="<%= Routes.session_path(QuadquizaminosWeb.Endpoint, :anonymous )%>" >
              Sign in anonymously
            </a>
        </div>
        </div>
        """

      :tailwind ->
        ~E"""
        <%= oath_sign_in(:tailwind) %>
        <a class="block px-4 py-2 mt-2 text-sm font-semibold bg-transparent dark-mode:bg-transparent dark-mode:hover:bg-gray-600 dark-mode:focus:bg-gray-600 dark-mode:focus:text-white dark-mode:hover:text-white dark-mode:text-gray-200 md:mt-0 hover:text-gray-900 focus:text-gray-900 hover:bg-gray-200 focus:bg-gray-200 focus:outline-none focus:shadow-outline"
        href="<%= Routes.session_path(QuadquizaminosWeb.Endpoint, :anonymous )%>" > Sign in anonymously
            </a>
        """
    end
  end

  defp oath_sign_in(style \\ :milligram)

  defp oath_sign_in(:milligram) do
    ~E"""
    <div class="dropdown">
    <button class="dropbtn">Sign In</button>
      <div class="dropdown-content">
          <a class = "button" href="<%= Routes.session_path(QuadquizaminosWeb.Endpoint, :new) %>">
          Sign in with handle
          </a>
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

  defp oath_sign_in(:tailwind) do
    dropdown_item_class = @dropdown_item_class

    ~E"""
      <a class="<%= dropdown_item_class %>" href="<%= Routes.session_path(QuadquizaminosWeb.Endpoint, :new) %>">
      Handle
      </a>
      <a class="<%= dropdown_item_class %>" href="<%= Routes.auth_path(QuadquizaminosWeb.Endpoint, :request, "github") %>">
       GitHub
      </a>
      <a class="<%= dropdown_item_class %>" href="<%= Routes.auth_path(QuadquizaminosWeb.Endpoint, :request, "google") %>">
       Google
      </a>
      <a class="<%= dropdown_item_class %>" href="<%= Routes.auth_path(QuadquizaminosWeb.Endpoint, :request, "linkedin") %>">
       LinkedIn
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
     <a class="button" href="<%= Routes.admin_contests_path(QuadquizaminosWeb.Endpoint, :index) %>">
     Contest
     </a>
     <a class = "button" href="<%= Routes.admin_live_path(QuadquizaminosWeb.Endpoint, QuadquizaminosWeb.AdminLive) %>">
     Login Level
     </a>
    """
  end
end
