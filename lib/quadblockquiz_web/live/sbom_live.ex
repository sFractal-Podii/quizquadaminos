defmodule QuadblockquizWeb.SbomLive do
  use QuadblockquizWeb, :live_view

  def render(assigns) do
    assigns = sbom_files(assigns)

    ~H"""
    <p>SBOMs for this site are available in several formats and serializations.</p>
    <%= for {k, v} <- @sbom_files do %>
      <ol><%= k %></ol>
      <%= for file <- v do %>
        <li><%= link(file, to: ["sbom/", file]) %></li>
      <% end %>
    <% end %>
    """
  end

  #   debian.bullseye_slim-cyclonedx-bom.json
  # debian.bullseye_slim-cyclonedx-bom.xml
  # debian.bullseye_slim-spdx-bom.json
  # debian.bullseye_slim-spdx-bom.spdx
  # quadblockquiz.0.24.0-cyclonedx-sbom.1.0.0.json
  # quadblockquiz.0.24.0-cyclonedx-sbom.1.0.0.xml
  # quadblockquiz.0.24.0-spdx-sbom.1.0.0.spdx
  # quadblockquiz.0.25.0-cyclonedx-sbom.1.0.0.json
  # quadblockquiz.0.25.0-cyclonedx-sbom.1.0.0.xml
  # quadblockquiz.0.25.0-spdx-sbom.1.0.0.spdx
  # quadblockquiz_vex_20211214_no_log4j.html
  # quadblockquiz_vex_20211214_no_log4j.json
  # quadquizaminos.0.14.6-spdx-sbom.1.0.0.spdx

  defp sbom_files(assigns) do
    files =
      :quadblockquiz
      |> Application.app_dir("/priv/static/.well-known/sbom")
      |> File.ls!()

    sbom_files =
      Enum.reduce(["cyclonedx", "spdx", "vex"], %{}, fn filter, acc ->
        Map.put(acc, filter, filter_files(files, filter))
      end)

    assign_new(assigns, :sbom_files, fn -> sbom_files end)
  end

  defp filter_files(files, filter) do
    regex = Regex.compile!(filter)
    files |> Enum.filter(fn file -> Regex.match?(regex, file) end)
  end
end
