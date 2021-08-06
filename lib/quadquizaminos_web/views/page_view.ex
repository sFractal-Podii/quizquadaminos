defmodule QuadquizaminosWeb.PageView do
  use QuadquizaminosWeb, :view
  alias Quadquizaminos.Accounts
  @bom_dir "/home/app/prod/lib/quadquizaminos/priv/static/.well-known/sbom"

  def render("instructions.html", _params) do
    QuadquizaminosWeb.Instructions.game_instruction()
  end

  def render("sbom.html", _params) do
    sbom_files = File.ls!(@bom_dir)

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

end
