defmodule QuadblockquizWeb.SharedLive.AskEmailComponent do
  use QuadblockquizWeb, :live_component
  alias Quadblockquiz.Accounts

  def update(assigns, socket) do
    changeset = Accounts.change_user(assigns.current_user)
    {:ok, socket |> assign(form: to_form(changeset), redirect_to: assigns.redirect_to)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h3>What's your email address?</h3>
      <.form for={@form} phx-change="validate" phx-submit="update_email" phx-target={@myself}>
        <label>Email</label>
        <.input type="email" field={@form[:email]} />
        <.input type="hidden" field={@form[:uid]} />
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

    {:noreply, socket |> assign(form: to_form(changeset))}
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
        {:noreply, socket |> assign(form: to_form(changeset))}
    end
  end
end
