defmodule JiraWeb.AuthController do
  use JiraWeb, :controller
  alias Jira.Users
  alias Jira.User

  def form(conn, params) do
    changeset = Users.new_user_changeset()
    render(conn, "form.html", changeset: changeset)
  end

  def login(conn, %{"user" => user_params}) do
    case Users.login(user_params) do
      {:ok, user} ->
        redirect_to_path = get_session(conn, :request_path) || "/"

        conn
        |> put_session(:current_user, user)
        |> put_flash(:info, "#{user.name} login successfully.")
        |> redirect(to: project_path(conn, :index))

      {:error, :name_and_password_does_not_match} ->
        conn
        |> put_flash(:error, ":name_and_password_does_not_match")
        |> redirect(to: auth_path(conn, :form))

      {:error, :user_not_found} ->
        conn
        |> put_flash(:error, ":user_not_found")
        |> redirect(to: auth_path(conn, :form))
    end
  end

  def logout(conn, _params) do
    conn
    |> put_session(:current_user, nil)
    |> put_flash(:info, "User logged out successfully.")
    |> redirect(to: "/login")
  end
end

## session
