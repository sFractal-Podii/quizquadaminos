defmodule QuadblockquizWeb.QuizModalComponent do
  use QuadblockquizWeb, :live_component
  alias Quadblockquiz.QnA

  def render(%{category: nil} = assigns) do
    ~H"""
    <div style="text-align:center;">
      <button phx-click="unpause">Continue</button>
      <br />
      <%= for category <- QnA.remove_used_categories(@file_path, @categories) do %>
        <button phx-click="choose_category" phx-value-category={category}>
          <%= Macro.camelize(category) %>
        </button>
      <% end %>
      <br />
      <%= show_powers(assigns) %><br />
      <button phx-click="endgame" class="red">End Game</button>
      <br />
    </div>
    """
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="float-right">
        <h2><b>Total Score:</b><%= @score %></h2>
      </div>
      <br />
      <h2><%= raw(@qna.question) %></h2>
      <h2>Answer</h2>
      <%= choices(assigns, @qna.type) %>
      <br />
      <%= unless Enum.empty?(@qna.score) do %>
        <h2>Scores</h2>
        <ul>
          <li>
            Right answer:<b>+<%= @qna.score["Right"] %></b>
          </li>
          <li>
            Wrong answer:<b>-<%= @qna.score["Wrong"] %></b>
          </li>
        </ul>
      <% end %>
    </div>
    """
  end

  defp show_powers(assigns) do
    ~H"""
    <%= for power <- @powers do %>
      <i
        class={"#{prefix(power)} #{power_icon(power)}"}
        title={power |> to_string()}
        phx-click="powerup"
        phx-value-powerup={power}
      >
      </i>
    <% end %>
    """
  end

  defp choices(assigns, "free-form") do
    ~H"""
    <.form :let={f} for={%{}} as={:quiz} phx-submit="check_answer">
      <%= text_input(f, :guess) %>
      <button class="button-outline" phx-click="skip-question">Skip Question</button> <br />
      <%= submit("Continue") %>
    </.form>
    """
  end

  defp choices(assigns, category) do
    assigns = assign_new(assigns, :category, fn -> category end)

    ~H"""
    <.form :let={f} for={%{}} as={:quiz} phx-submit="check_answer">
      <%= for {answer, index}<- @qna.choices do %>
        <%= label do %>
          <%= radio_button(f, :guess, answer, value: index) %>
          <%= answer %>
        <% end %>
        <!-- end label -->
      <% end %>
      <br />
      <button class="button-outline" phx-click="skip-question" phx-value-category={@category}>
        Skip Question
      </button>
      <%= submit("Continue") %>
    </.form>
    """
  end

  defp power_icon(power) do
    %{
      deleteblock: "fa-minus-square",
      addblock: "fa-plus-square",
      moveblock: "fa-arrows-alt",
      clearblocks: "fa-eraser",
      speedup: "fa-fast-forward",
      slowdown: "fa-fast-backward",
      fixvuln: "fa-wrench",
      fixlicense: "fa-screwdriver",
      rm_all_vulns: "fa-hammer",
      rm_all_lic_issues: "fa-tape",
      superpower: "fa-superpowers",
      cyberinsurance: "fa-file-contract"
    }
    |> Map.fetch!(power)
  end

  defp prefix(:superpower), do: "fab"
  defp prefix(_power), do: "fas"
end
