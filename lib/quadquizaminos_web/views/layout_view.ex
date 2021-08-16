defmodule QuadquizaminosWeb.LayoutView do
  use QuadquizaminosWeb, :view

  defp admin_dropdown do
    ~E"""
    <div class="dropdown">
    <a href="/admin" class="dropbtn">
    Admin
    <i class="fa fa-caret-down"></i>
    </a>
     <div class="dropdown-content">
     <a class="button" href="<%= Routes.contests_path(QuadquizaminosWeb.Endpoint, :index) %>">
     Contest
     </a>
     <a class = "button" href="<%= Routes.live_path(QuadquizaminosWeb.Endpoint, QuadquizaminosWeb.AdminLive) %>">
     Login
     </a>
    """
  end
end
