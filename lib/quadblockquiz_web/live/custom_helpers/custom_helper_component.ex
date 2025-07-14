defmodule QuadblockquizWeb.CustomHelperComponent do
  use Phoenix.Component
  alias QuadblockquizWeb.Router.Helpers, as: Routes

  alias Quadblockquiz.Accounts

  @dropdown_item_class "block px-4 py-2 mt-2 text-sm font-semibold bg-transparent dark-mode:bg-transparent dark-mode:hover:bg-gray-600 dark-mode:focus:bg-gray-600 dark-mode:focus:text-white dark-mode:hover:text-white dark-mode:text-gray-200 md:mt-0 hover:text-gray-900 focus:text-gray-900 hover:bg-gray-200 focus:bg-gray-200 focus:outline-none focus:shadow-outline"

  def hide_or_show_sign_up_button(assigns) do
    assigns =
      assigns
      |> assign_new(:style, fn -> :milligram end)
      |> assign_new(:dropdown_item_class, fn -> @dropdown_item_class end)

    ~H"""
    {selected_login_level() |> sign_up_button(assigns)}
    """
  end

  defp sign_up_button("by_config", assigns) do
    case assigns.style do
      :milligram ->
        ~H"""
        <a class="button" href={Routes.auth_path(QuadblockquizWeb.Endpoint, :request, "github")}>
          <i class="fas fa-github"></i> Sign in with GitHub
        </a>
        """

      :tailwind ->
        ~H"""
        <a
          class="block px-4 py-2 mt-2 text-sm font-semibold bg-transparent dark-mode:bg-transparent dark-mode:hover:bg-gray-600 dark-mode:focus:bg-gray-600 dark-mode:focus:text-white dark-mode:hover:text-white dark-mode:text-gray-200 md:mt-0 hover:text-gray-900 focus:text-gray-900 hover:bg-gray-200 focus:bg-gray-200 focus:outline-none focus:shadow-outline"
          href={Routes.auth_path(QuadblockquizWeb.Endpoint, :request, "github")}
        >
          Github Sign In
        </a>
        """
    end
  end

  defp sign_up_button(login_level, assigns) do
    assigns = assign_new(assigns, :login_level, fn -> login_level end)

    case assigns.style do
      :milligram ->
        ~H"""
        {sign_up_button(assigns)}
        """

      :tailwind ->
        ~H"""
        {sign_up_button(assigns)}
        """
    end
  end

  defp sign_up_button(%{style: :milligram} = assigns) do
    ~H"""
    <div class="dropdown">
      <button class="dropbtn">Sign In</button>
      <div class="dropdown-content">
        <a class="button" href={Routes.session_path(QuadblockquizWeb.Endpoint, :new)}>
          Sign in with handle
        </a>
        <a class="button" href={Routes.auth_path(QuadblockquizWeb.Endpoint, :request, "github")}>
          <i class="fas fa-github"></i> Sign in with GitHub
        </a>
        <%= if @login_level == "anonymous_login" do %>
          <.anonymous_sign_in style={:milligram} />
        <% end %>
      </div>
    </div>
    """
  end

  defp sign_up_button(%{style: :tailwind} = assigns) do
    ~H"""
    <a class={@dropdown_item_class} href={Routes.session_path(QuadblockquizWeb.Endpoint, :new)}>
      Handle
    </a>
    <a
      class={@dropdown_item_class}
      href={Routes.auth_path(QuadblockquizWeb.Endpoint, :request, "github")}
    >
      GitHub
    </a>

    <%= if @login_level == "anonymous_login" do %>
      <.anonymous_sign_in style={:tailwind} />
    <% end %>
    """
  end

  defp anonymous_sign_in(%{style: :milligram} = assigns) do
    ~H"""
    <a class="button" href={Routes.session_path(QuadblockquizWeb.Endpoint, :anonymous)}>
      Sign in anonymously
    </a>
    """
  end

  defp anonymous_sign_in(%{style: :tailwind} = assigns) do
    ~H"""
    <a
      class="block px-4 py-2 mt-2 text-sm font-semibold bg-transparent dark-mode:bg-transparent dark-mode:hover:bg-gray-600 dark-mode:focus:bg-gray-600 dark-mode:focus:text-white dark-mode:hover:text-white dark-mode:text-gray-200 md:mt-0 hover:text-gray-900 focus:text-gray-900 hover:bg-gray-200 focus:bg-gray-200 focus:outline-none focus:shadow-outline"
      href={Routes.session_path(QuadblockquizWeb.Endpoint, :anonymous)}
    >
      Sign in anonymously
    </a>
    """
  end

  defp selected_login_level do
    case Accounts.get_selected_login_level() do
      nil -> nil
      login_level -> login_level.name
    end
  end

  def admin_dropdown(assigns) do
    ~H"""
    <div class="dropdown">
      <a href="/admin" class="dropbtn">
        Admin <i class="fa fa-caret-down"></i>
      </a>
      <div class="dropdown-content">
        <a class="button" href={Routes.admin_contests_path(QuadblockquizWeb.Endpoint, :index)}>
          Contest
        </a>
        <a
          class="button"
          href={Routes.admin_live_path(QuadblockquizWeb.Endpoint, QuadblockquizWeb.AdminLive)}
        >
          Login Level
        </a>
      </div>
    </div>
    """
  end

  def display_name_and_avatar(%{current_user: "anonymous"} = assigns) do
    ~H"""
    <div></div>
    """
  end

  def display_name_and_avatar(assigns) do
    ~H"""
    <h2>Welcome, {@current_user.name}!</h2>
    <div>
      <img src={@current_user.avatar} class="h-44 w-44" />
    </div>
    """
  end
end
