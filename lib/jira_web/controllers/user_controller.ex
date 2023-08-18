defmodule JiraWeb.UserController do
    use JiraWeb, :controller
    alias Jira.Users
    alias Jira.User

   # plug :authenticate

    def index(conn, params) do
        users = Users.list_users(params)
        render(conn, "index.html", users: users)
    end

    def show(conn, %{"id" => id}) do
        user = Users.get_user(id)
        render(conn, "show.html", user: user)
    end

    def new(conn, _params) do
        changeset = Users.change_user(%User{})
        render(conn, "new.html", changeset: changeset)
    end

    def create(conn, %{"user" => user_params}) do
        case Users.create_user(user_params) do
          {:ok, user} ->
            conn
            |> put_flash(:info, "#{user.name} created successfully.")
            |> redirect(to: JiraWeb.Router.Helpers.user_path(conn, :show, user))
    
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      end

    def delete(conn, %{"id" => id}) do
        with %User{} = user <- Users.get_user(id),
             {:ok, user} <- Users.delete_user(user) do
          conn
          |> put_flash(:info, "#{user.name} deleted successfully.")
          |> redirect(to: JiraWeb.Router.Helpers.user_path(conn, :index))
        else
          nil ->
            conn
            |> put_flash(:error, "User not found.")
            |> redirect(to: JiraWeb.Router.Helpers.user_path(conn, :index))
        end
      end
end