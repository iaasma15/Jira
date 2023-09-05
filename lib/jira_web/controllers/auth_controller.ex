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

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Login and Password does not match")
        |> render("form.html", changeset: changeset)
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
