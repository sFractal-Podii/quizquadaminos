defmodule QuadblockquizWeb.LayoutViewTest do
  use QuadblockquizWeb.ConnCase, async: true

  # When testing helpers, you may want to import Phoenix.HTML and
  # use functions such as safe_to_string() to convert the helper
  # result into an HTML string.
  # import Phoenix.HTML

  test "user can see a table of footer content", %{conn: conn} do
    conn = get(conn, "/")
    assert conn.resp_body =~ "<a href= /contests >Contests</a>"
    assert conn.resp_body =~ "<a href= /contest-prizes >Contest prizes</a>"
    assert conn.resp_body =~ "<a href= /contest_rules >Contest rules</a>"
    assert conn.resp_body =~ "<a href= /termsofservice > Terms Of Service </a>"
    assert conn.resp_body =~ "<a href= /privacy > Privacy </a>"
    assert conn.resp_body =~ "<a href= /.well-known/sbom >SBOM</a>"
  end
end
