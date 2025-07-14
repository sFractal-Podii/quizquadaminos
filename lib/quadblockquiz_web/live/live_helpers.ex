defmodule QuadblockquizWeb.LiveHelpers do
  @moduledoc false
  import Phoenix.Component

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.user_index_path(@socket, :index)}>
        <.live_component
          module={QuadblockquizWeb.UserLive.FormComponent}
          id={@user.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.user_index_path(@socket, :index)}
          user: @user
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content fade-in-scale"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <.link
            patch={@return_to}
            id="close"
            class="phx-modal-close fs-3 text-dark"
            phx-click={hide_modal()}
          >
            <span aria-hidden="true">&times;</span>
          </.link>
        <% else %>
          <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal(:unpause)}>&times;</a>
        <% end %>

        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  defp hide_modal(:unpause) do
    hide_modal() |> JS.push("unpause")
  end

  defp hide_modal do
    %JS{}
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end
