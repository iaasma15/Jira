defmodule JiraWeb.ProjectController do
  use JiraWeb, :controller
  alias Jira.Projects
  alias Jira.Project

  plug :find_project when action in [:edit, :update, :delete]

  def index(conn, params) do
    current_user = conn.assigns[:current_user]
    projects = Projects.user_projects(current_user.id, params["search"])
    render(conn, "index.html", projects: projects)
  end

  def edit(conn, _params) do
    project = conn.assigns[:project]
    changeset = Project.changeset(project, %{})
    render(conn, "edit.html", project: project, changeset: changeset)
  end

  def update(conn, %{"project" => project_params}) do
    project = conn.assigns[:project]

    case Projects.update_project(project, project_params) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "#{project.name} updated successfully.")
        |> redirect(to: project_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", project: project, changeset: changeset)
    end
  end

  def new(conn, _params) do
    changeset = Projects.new_project_changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"project" => params}) do
    current_user = conn.assigns[:current_user]
    project_params = Map.put(params, "user_id", current_user.id)

    case Projects.create_project(project_params) do
      {:ok, project} ->
        conn
        |> put_flash(:info, "#{project.name} created successfully.")
        |> redirect(to: project_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, _params) do
    project = conn.assigns[:project]
    {:ok, project} = Projects.delete_project(project)

    conn
    |> put_flash(:info, "#{project.name} deleted successfully.")
    |> redirect(to: project_path(conn, :index))
  end

  def find_project(conn, _opts) do
    current_user = conn.assigns[:current_user]
    id = conn.params["id"]

    case Projects.user_project(current_user.id, id) do
      %Project{} = project ->
        assign(conn, :project, project)

      nil ->
        conn
        |> put_flash(:error, "There are no such project")
        |> redirect(to: project_path(conn, :index))
        |> halt()
    end
  end
end
