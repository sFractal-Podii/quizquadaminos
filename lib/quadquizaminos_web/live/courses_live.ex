defmodule QuadquizaminosWeb.CourseLive do
  use Phoenix.LiveView
  import Phoenix.HTML
  import Phoenix.HTML.Form
  alias QuadquizaminosWeb.Router.Helpers, as: Routes
  alias Quadquizaminos.Courses

  @impl true
  def mount(_arg0, _session, socket) do
    {
      :ok,
      assign(
        socket,
        course: [],
        chapter: [],
        chapter_files: [],
        question: nil
      )
    }
  end

  @impl true
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

  @impl true
  def render(%{live_action: :show} = assigns) do
    ~L"""
    <div class="container">
    <div class="row">
      <div class="column">
        <%= for chapter <- Courses.chapter_list(assigns.course) do%>
        <ul>
        <a href="#" phx-click="go-to-chapter" phx-value-chapter="<%= chapter%>" > <%= chapter %> </a> <br />
        </ul>
        <% end %>
      </div> <!-- column -->

      <div class="column">
      <%= for file <- @chapter_files do %>
      <ul>
       <a href="#" phx-click="go-to-question" phx-value-question="<%= file %>" > <%= file %> </a> <br />
       </ul>
      <% end %>
      </div> <!-- column -->

      <div class="column column-75">
      <%= raw @question %>
      </div> <!-- column -->

     </div> <!-- row -->
     </div> <!-- container -->
    """
  end

  @impl true
  def render(assigns) do
    ~L"""
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
    """
  end

  @impl true
  def handle_params(%{"chapter" => chapter, "course" => course}, _uri, socket) do
    {:noreply, socket |> assign(course: course, chapter: chapter)}
  end

  @impl true
  def handle_params(%{"course" => course}, _url, socket) do
    {:noreply, socket |> assign(course: course)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("go-to-chapter", %{"chapter" => chapter}, socket) do
    files = Courses.question_list(socket.assigns.course, chapter)
    {:noreply, socket |> assign(chapter_files: files, chapter: chapter, question: nil)}
  end

  @impl true
  def handle_event("go-to-question", %{"question" => question}, socket) do
    question = Courses.question(socket.assigns.course, socket.assigns.chapter, question)
    {:noreply, socket |> assign(question: question)}
  end

  def answers(content) do
    [question, answer] = content
    answer
  end

  def question(content) do
    [question, answer] = content
    question
  end
end
