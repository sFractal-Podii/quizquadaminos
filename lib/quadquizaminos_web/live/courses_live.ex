defmodule QuadquizaminosWeb.CourseLive do
  use Phoenix.LiveView
  import Phoenix.HTML
  import Phoenix.HTML.Link
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

        <div phx-click="chapter" phx-value-chapter= <%= chapter %> >
        <%= link  chapter, to: ["#{assigns.course}/", chapter] %>
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
       <%= link  course, to: ["courses/", course] %>
       </td>
      </tr>
       <% end %>
       </table>
     <% end %>
     </div>
      """
    end
    
    def render(%{chapter: chapter } = assigns) do
      assigns.chapter |> IO.inspect(label: "(((((((())))))))))))")
     ~L"""
     <h1> Questions </h1>
     """
   end





    # def handle_event("course", %{course: course}, socket) do
    #   {:noreply, socket |> assign(course: course)}
    # end
   def handle_event("chapter", %{"chapter" => chapter}, socket) do
    {:noreply, socket |> assign(chapter: chapter) |> IO.inspect(label: "((((chapter))))))))")}
   end

    def handle_params(%{"course" => course}, _url, socket) do
      {:noreply, socket |> assign(course: course)}
    end

    def handle_params(%{"chapter" => chapter}, _uri, socket) do
      {:noreply, socket |> assign(chapter: chapter)}
    end

    def handle_params(_params, _url, socket) do
      {:noreply, socket}
    end




end
