defmodule QuadblockquizWeb.CourseLive do
  use QuadblockquizWeb, :live_view
  import Phoenix.Component

  alias Quadblockquiz.Accounts
  alias Quadblockquiz.Courses

  alias QuadblockquizWeb.Router.Helpers, as: Routes

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
    ~H"""
    <div class="container">
      <table>
        <th>
          <h1>Questions</h1>
        </th>

        <%= for content <- Courses.questions(@chapter,@course) do %>
          <tr>
            <td>
              {raw(question(content))}
              <%= for answer <- answers(content) do %>
                <%= label do %>
                  {answer}
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
    ~H"""
    <div class="container">
      <div class="row">
        <div class="column column-25">
          <%= for chapter <- Courses.chapter_list(assigns.course) do %>
            <ul>
              <.link navigate={
                Routes.tetris_path(@socket, :tetris, %{course: @course, chapter: chapter})
              }>
                {"start #{chapter}"}
              </.link>
            </ul>
          <% end %>
        </div>
        <!-- column -->
        <div class="column">
          <%= for file <- @chapter_files do %>
            <ul>
              <a href="#" phx-click="go-to-question" phx-value-question={file}>{file}</a> <br />
            </ul>
          <% end %>
        </div>
        <!-- column -->
        <div class="column column-75">
          {raw(@question)}
        </div>
        <!-- column -->
      </div>
      <!-- row -->
    </div>
    <!-- container -->
    """
  end

  @impl true
  def render(assigns) do
    ~H"""
    <%= if @has_email? do %>
      <h1 class="pt-10 text-5xl font-normal">Courses</h1>
      <div class="grid grid-cols-1 md:grid-cols-3 md:gap-4 md:pt-10 ">
        <%= for course <- Courses.courses_list() do %>
          <div class="pt-4 md:pt-0 shadow md:shadow-none flex flex-row md:flex-col border-t-0 md:border border-grey-200 rounded-xl">
            <div class="pt-4 pb-0 md:pt-0">
              <img
                class="rounded-lg h-20 w-64 md:w-full md:h-52"
                src={
                  Routes.static_path(
                    QuadblockquizWeb.Endpoint,
                    "/images/Supply_Chain_Sandbox_logo_dark_draft.png"
                  )
                }
                alt="course chapter"
              />
            </div>
            <div class="p-2 md:p-4 md:space-y-4">
              <div>
                <h1 class="text-blue-600 text-sm font-bold md:text-black md:text-2xl md:font-normal">
                  {course}
                </h1>
                <p class="text-xs font-normal md:text-base md:font-light md:text-gray-600">
                  This is a future feature. Ignore
                </p>
                <p class="text-blue-600 underline float-right text-xs font-normal md:invisible">
                  <.link patch={Routes.course_path(@socket, :show, course)}>start course</.link>
                </p>
              </div>
              <div class="hidden md:flex md:justify-between">
                <div>
                  <h2 class="text-xl font-normal  ">Mentor</h2>
                  <img
                    class="rounded-full h-12 w-12 flex items-center justify-center "
                    src={Routes.static_path(QuadblockquizWeb.Endpoint, "/images/user-avatar.jpeg")}
                    alt="user avatar"
                  />
                </div>
                <div class="pt-7">
                  <button class="rounded-sm bg-blue-600 text-white flex items-center justify-center text-base font-normal h-12 w-40">
                    <.link patch={Routes.course_path(@socket, :show, course)}>start course</.link>
                  </button>
                </div>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    <% else %>
      <div class="container">
        <div class="row">
          <div class="column column-50 column-offset-25">
            {ask_for_email(assigns)}
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
    ~H"""
    <%= unless @current_user == nil ||  @current_user.email do %>
      <.live_component
        module={QuadblockquizWeb.SharedLive.AskEmailComponent}
        id={2}
        current_user={@current_user}
        redirect_to={@current_uri}
      />
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
