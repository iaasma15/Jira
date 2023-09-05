defmodule JiraWeb.ProjectController do
  use JiraWeb, :controller
  import Ecto.Query
  alias Jira.Projects
  alias Jira.Project

  def index(conn, params) do
    current_user = conn.assigns[:current_user]
    projects = Projects.user_projects(current_user.id, params["search"])
    render(conn, "index.html", projects: projects)
  end

  def show(conn, %{"id" => id}) do
    project = Projects.get_project(id)
    render(conn, "show.html", project: project)
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

  def delete(conn, %{"id" => id}) do
    with %Project{} = project <- Projects.get_project(id),
         {:ok, project} <- Projects.delete_project(project) do
      conn
      |> put_flash(:info, "#{project.name} deleted successfully.")
      |> redirect(to: project_path(conn, :index))
    else
      nil ->
        conn
        |> put_flash(:error, "Project not found.")
        |> redirect(to: project_path(conn, :index))
    end
  end
end
