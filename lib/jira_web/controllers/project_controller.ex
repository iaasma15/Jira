defmodule JiraWeb.ProjectController do
    use JiraWeb, :controller
    import Ecto.Query
    alias Jira.Projects
    alias Jira.Project


    def index(conn, params) do
        projects = Projects.list_projects(params)
        render(conn, "index.html", projects: projects)
    end

    def show(conn, %{"id" => id}) do
        project = Projects.get_project(id)
        render(conn, "show.html", project: project)
    end

    def new(conn, _params) do
        changeset = Projects.change_project(%Project{})
        render(conn, "new.html", changeset: changeset)
    end

    def myprojects(conn, params) do
        projects_query = from p in Project,
          where: p.name == "myprojects", 
          select: p
          projects = Jira.Repo.all(projects_query)

        render(conn, "myprojects.html", projects: projects)
      end
      

    def create(conn, %{"project" => project_params}) do
        case Projects.create_project(project_params) do
          {:ok, project} ->
            conn
            |> put_flash(:info, "#{project.name} created successfully.")
            |> redirect(to: JiraWeb.Router.Helpers.project_path(conn, :show, project))
      
          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "new.html", changeset: changeset)
        end
      end

end