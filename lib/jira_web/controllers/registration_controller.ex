defmodule JiraWeb.RegistrationController do
  use JiraWeb, :controller
  alias Jira.Users

  def form(conn, _params) do
    changeset = Users.new_user_changeset()
    render(conn, "form.html", changeset: changeset)
  end

  def register(conn, %{"user" => user_params}) do
    case Users.register(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "#{user.name} registered successfully.")
        |> redirect(to: "/login")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "form.html", changeset: changeset)
    end
  end
end
