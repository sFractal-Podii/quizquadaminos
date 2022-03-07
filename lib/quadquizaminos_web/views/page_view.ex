defmodule QuadquizaminosWeb.PageView do
  use QuadquizaminosWeb, :view

  def render("sbom.html", _params) do
    files =
      :quadquizaminos
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
       <img src="<%= current_user.avatar %>" />
     </div>
    """
  end
end
