defmodule QuadblockquizWeb.SharedLive.AskEmailComponent do
  use QuadblockquizWeb, :live_component
  alias Quadblockquiz.Accounts

  def update(assigns, socket) do
    changeset = Accounts.change_user(assigns.current_user)
    {:ok, socket |> assign(changeset: changeset, redirect_to: assigns.redirect_to)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h3>What's your email address?</h3>
      <.form
        :let={f}
        for={@changeset}
        phx-change="validate"
        phx-submit="update_email"
        phx-target={@myself}
      >
        {label(f, :email)}
        {text_input(f, :email, type: :email)}
        {error_tag(f, :email)}
        {text_input(f, :uid, type: :hidden)}
        <button>Update Email</button>
      </.form>
    </div>
    """
  end

  def handle_event("validate", %{"user" => params}, socket) do
    changeset =
      %Accounts.User{}
      |> Accounts.change_user(params)
      |> Map.put(:action, :insert)

    {:noreply, socket |> assign(changeset: changeset)}
  end

  def handle_event("update_email", %{"user" => params}, socket) do
    redirect_path = URI.parse(socket.assigns.redirect_to).path

    case Accounts.update_email(params) do
      {:ok, user} ->
        send(self(), {:update_user, current_user: user, has_email?: true})

        {:noreply,
         socket
         |> assign(current_user: user, has_email?: true)
         |> push_patch(to: redirect_path)}

      {:error, changeset} ->
        {:noreply, socket |> assign(changeset: changeset)}
    end
  end
end
