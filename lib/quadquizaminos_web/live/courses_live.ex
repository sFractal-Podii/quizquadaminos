defmodule QuadquizaminosWeb.CourseLive do
  use Phoenix.LiveView
  import Phoenix.HTML
  import Phoenix.HTML.Form
  alias Quadquizaminos.Accounts
  alias Quadquizaminos.Courses
  alias QuadquizaminosWeb.Router.Helpers, as: Routes
  @impl true
  def mount(_arg0, %{"uid" => user_id}, socket) do
    current_user = user_id |> Accounts.current_user()

    {
      :ok,
      assign(
        socket,
        course: [],
        chapter: [],
        chapter_files: [],
        question: nil,
        current_user: current_user,
        has_email?: Accounts.has_email?(current_user)
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
      <div class="column column-25">
        <%= for chapter <- Courses.chapter_list(assigns.course) do%>
        <ul>
        <%= live_redirect "start #{chapter}", to: Routes.tetris_path(@socket, :tetris, %{course: @course, chapter: chapter}) %>

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
     <%= if @has_email? do %>
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
       <% else %>
       <div class ="container">
        <div class="row">
            <div class="column column-50 column-offset-25">
              <%= ask_for_email(assigns) %>
            </div>
        </div>
      </div>  
      <% end %>
      
    """
  end

  @impl true
  def handle_params(%{"chapter" => chapter, "course" => course}, uri, socket) do
    {:noreply, socket |> assign(course: course, chapter: chapter, current_uri: uri)}
  end

  @impl true
  def handle_params(%{"course" => course}, uri, socket) do
    {:noreply, socket |> assign(course: course, current_uri: uri)}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    {:noreply, socket |> assign(current_uri: uri)}
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

  @impl true
  def handle_info({:update_user, assigns}, socket) do
    {:noreply, assign(socket, assigns)}
  end

  defp ask_for_email(assigns) do
    ~L"""
    <%= unless @current_user == nil ||  @current_user.email do %>
    <%= live_component @socket,  QuadquizaminosWeb.SharedLive.AskEmailComponent, id: 2, current_user: @current_user, redirect_to: @current_uri %>
    <% end %>
    """
  end

  def answers(content) do
    [_question, answer] = content
    answer
  end

  def question(content) do
    [question, _answer] = content
    question
  end
end
