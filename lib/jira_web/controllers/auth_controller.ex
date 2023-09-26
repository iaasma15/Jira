defmodule JiraWeb.AuthController do
  use JiraWeb, :controller
  alias Jira.Users

  def form(conn, _params) do
    changeset = Users.new_user_changeset()
    render(conn, "form.html", changeset: changeset, login: "")
  end

  def login(conn, %{"user" => user_params}) do
    case Users.login(user_params) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user)
        |> put_flash(:info, "#{user.name} login successfully.")
        |> redirect(to: project_path(conn, :index))

      {:error, changeset} ->
        login = Map.get(user_params, "login", "")

        conn
        |> put_flash(:error, "Login and Password does not match")
        |> render("form.html", changeset: changeset, login: login)
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
