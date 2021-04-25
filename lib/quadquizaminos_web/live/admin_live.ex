defmodule QuadquizaminosWeb.AdminLive do
  use Phoenix.LiveView
  import Phoenix.HTML

  def render(assigns) do
    ~L"""
    <div class="container">
    <h1>users level of login</h1>
     <form  phx-change="login_levels">
     <label>
    <input type="radio" id="login_levels" name="login_levels" value="by_config" checked> by_config
    </label>
    <label>
    <input type="radio" id="login_levels" name="login_levels" value="oauth_login"> oauth_login
    </label>
    <label>
    <input type="radio" id="login_levels" name="login_levels" value="anonymous_login">anonymous_login
    </label>
    </form> 
    </div>
    """
  end
end
