defmodule QuadquizaminosWeb.CourseLive do
  use Phoenix.LiveView
  import Phoenix.HTML
  import Phoenix.HTML.Form
  alias QuadquizaminosWeb.Router.Helpers, as: Routes
  alias Quadquizaminos.Courses

  def mount(_arg0, _session, socket) do
    {
      :ok, assign(
      socket,
      course: [],
      chapter: []
      )}
  end



  def handle_params(%{"chapter" => chapter, "course" => course}, _uri, socket) do
    {:noreply, socket |> assign(course: course, chapter: chapter) }
  end

  def render(%{live_action: :questions} = assigns) do
    ~L"""
    <div class="container">
    <table>
    <th>
    <h1> Questions </h1>
    <th>

    <%= for content <- Courses.questions(@chapter,@course) do %>
    <tr>
    <td>
      <%= raw(question(content)) %>
      <%= for answer <- answers(content) do %>
      <%= label do %>
      <%= answer %>
      <% end %>

      <% end %>

    </td>
    </tr>
      <% end %>
    </table>
    </div>
    """
  end

    def render(assigns) do
      ~L"""
      <div class="container">
      <%= if @live_action == :show do %>
      <h1> Chapter </h1>
      <table>
      <tr>
      <th>Name </th>
      </tr>
        <%= for chapter <- Courses.chapter_list(assigns.course) do%>
        <tr>
        <td>
        <%= live_patch chapter, to: Routes.course_path(@socket, :questions , @course, chapter) %>
        </td>
        </tr>
        <% end %>
     <% else %>
       <h1> Courses </h1>
       <table>
       <tr>
       <th>Name </th>
       </tr>
       <%= for course <- Courses.courses_list() do %>
       <tr>
       <td>
       <%= live_patch course, to: Routes.course_path(@socket, :show , course) %>
       </td>
      </tr>
       <% end %>
       </table>
     <% end %>
     </div>
      """
    end

    def handle_params(%{"course" => course}, _url, socket) do
      {:noreply, socket |> assign(course: course)}
    end

    def handle_params(_params, _url, socket) do
      {:noreply, socket}
    end

    def answers(content) do
      [question,answer] = content
      answer
    end

    def question(content) do
      [question,answer] = content
     question
    end

end
