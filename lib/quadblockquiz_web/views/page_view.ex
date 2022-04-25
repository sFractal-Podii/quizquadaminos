defmodule QuadblockquizWeb.PageView do
  use QuadblockquizWeb, :view
  alias Quadblockquiz.Accounts

  @button "bg-blue-700 font-normal text-white text-sm w-60 h-9 flex items-center justify-center"

  def render("sbom.html", _params) do
    files =
      :quadblockquiz
      |> Application.app_dir("/priv/static/.well-known/sbom")
      |> File.ls!()

    sbom_files =
      Enum.reduce(["cyclonedx", "spdx", "vex"], %{}, fn filter, acc ->
        Map.put(acc, filter, filter_files(files, filter))
      end)

    ~E"""
    <p>SBOMs for this site are available in several formats and serializations. </p>
    <%= for {k, v} <- sbom_files do %>
      <ol> <%= k %> </ol>
      <%= for file <- v do %>
          <li> <%= link file,  to: ["sbom/",file] %> </li>
      <% end %>
    <% end %>
    """
  end

  defp filter_files(files, filter) do
    regex = Regex.compile!(filter)
    files |> Enum.filter(fn file -> Regex.match?(regex, file) end)
  end

  def display_name_and_avatar("anonymous" = _current_user), do: ""

  def display_name_and_avatar(current_user) do
    ~E"""
     <h2>Welcome, <%= current_user.name %>!</h2>
     <div>
       <img src="<%= current_user.avatar %>"class="h-44 w-44"/>
     </div>
    """
  end

  def hide_or_show_sign_up_button do
    selected_login_level() |> sign_up_button()
  end

  defp sign_up_button("by_config") do
    ~E"""
    <a class="bg-blue-700 font-normal text-white text-sm w-60 h-9 flex items-center justify-center"
        href="<%= Routes.auth_path(QuadblockquizWeb.Endpoint, :request, "github") %>">Github Sign In</a>
    """
  end

  defp sign_up_button("oauth_login") do
    ~E"""
      <%= oath_sign_in()   %>
      </div>
    """
  end

  defp sign_up_button(_login_level) do
    ~E"""
    <%= oath_sign_in() %>
      <a class="bg-blue-700 font-normal text-white text-sm w-60 h-9 flex items-center justify-center"
         href="<%= Routes.session_path(QuadblockquizWeb.Endpoint, :anonymous )%>" > Sign in anonymously
      </a>
      </div>
    """
  end

  defp oath_sign_in do
    button = @button

    ~E"""
      <div class="grid space-y-4">
        <a class = "<%= button %>" href="<%= Routes.session_path(QuadblockquizWeb.Endpoint, :new) %>">
          Sign in with handle
        </a>
        <a class="<%= button %>" href="<%= Routes.auth_path(QuadblockquizWeb.Endpoint, :request, "github") %>">
          Sign in with GitHub
        </a>
        <a class = "<%= button %>" href="<%= Routes.auth_path(QuadblockquizWeb.Endpoint, :request, "google") %>">
          Sign in with Google
        </a>
        <a class = "<%= button %>" href="<%= Routes.auth_path(QuadblockquizWeb.Endpoint, :request, "linkedin") %>">
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
