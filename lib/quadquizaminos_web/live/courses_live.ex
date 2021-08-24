defmodule QuadquizaminosWeb.CourseLive do
  use Phoenix.LiveView
  import Phoenix.HTML
  alias QuadquizaminosWeb.Router.Helpers, as: Routes
  alias Quadquizaminos.Courses


  def mount(_arg0, _session, socket) do
    {
      :ok, assign(
      socket,
      courses: [],
      chapters: []
      )}

  end

    def render(assigns) do

      ~L"""
      <div class = "container">
      <h1> Courses </h1>
      <table>
      <tr>
      <th>Name </th>
      </tr>
      <%= for course <- add_courses(assigns) do %>
      <tr>
      <td class = "dropdown1" >
      <%= course %>
      </td>
      <td >
      <%= chapters_dropdown %>
      </td>
      <% end %>
      </table>
      </div>
      """
    end
    defp add_courses(assigns) do
      courses = assigns.courses ++ Courses.courses_list()
      courses
    end

    defp chapters_dropdown do
      ~E"""
      <div class="dropdown">
      <a href="/admin" class="dropbtn">
      Chapters
      <i class="fa fa-caret-down"></i>
      </a>
       <div class="dropdown-content">
       <a class="button" %>
       Chapters
       </a>
      """
    end



end
