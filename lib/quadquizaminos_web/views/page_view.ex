defmodule QuadquizaminosWeb.PageView do
  use QuadquizaminosWeb, :view

  def display_name_and_avatar(nil = _current_user), do: ""
  def display_name_and_avatar("anonymous" = _current_user), do: ""

  def display_name_and_avatar(current_user) do
    """
     <h2>Welcome, <%= current_user.name %>!</h2>
     <div>
       <img src="<%= current_user.avatar %>" />
     </div>
    """
  end
end
