defmodule JiraWeb.TaskController do
  use JiraWeb, :controller
  import Ecto.Query
  import Ecto.Repo
  alias Jira.Tasks
  alias Jira.Task
  alias Jira.Repo

  # plug :authenticate

  def index(conn, params) do
    ## getting from params
    project_id = params["project_id"]
    tasks = Tasks.project_tasks(project_id, params["search"])
    render(conn, "index.html", tasks: tasks, project_id: project_id)
  end

  def show(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)
    # |> Repo.preload(:project)
    render(conn, "task_description.html", task: task)
  end

  def new(conn, params) do
    project_id = params["project_id"]
    changeset = Tasks.new_task_changeset()
    render(conn, "new.html", changeset: changeset, project_id: project_id)
  end

  # def create(conn, %{"task" => task_params}) do
  #   current_project = get_session(conn, :current_project)
  #   task_params = Map.put(task_params, "project_id", current_project.id)

  #   case Tasks.create_task(task_params) do
  #     {:ok, task} ->
  #       conn
  #       |> put_flash(:info, "#{task.name} created successfully.")
  #       |> redirect(to: JiraWeb.Router.Helpers.project_task_path(conn, :index))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset)
  #   end
  # end

  def create(conn, %{"task" => task_params, "project_id" => project_id}) do
    task_params = Map.put(task_params, "project_id", project_id)

    case Tasks.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "#{task.name} created successfully.")
        |> redirect(to: project_task_path(conn, :index, project_id))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, project_id: project_id)
    end
  end

  def delete(conn, %{"id" => id, "project_id" => project_id}) do
    with %Task{} = task <- Tasks.get_task(id),
         {:ok, task} <- Tasks.delete_task(task) do
      conn
      |> put_flash(:info, "#{task.name} deleted successfully.")
      |> redirect(to: project_task_path(conn, :index, project_id))
    else
      nil ->
        conn
        |> put_flash(:error, "Task not found.")
        |> redirect(to: project_task_path(conn, :index, project_id))
    end
  end
end
