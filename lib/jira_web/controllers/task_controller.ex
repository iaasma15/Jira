defmodule JiraWeb.TaskController do
  use JiraWeb, :controller
  alias Jira.Tasks
  alias Jira.Task
  alias Jira.Projects
  alias Jira.Project

  plug :authorize_project

  def index(conn, %{"project_id" => project_id} = params) do
    tasks = Tasks.project_tasks(project_id, params["search"])
    render(conn, "index.html", tasks: tasks, project_id: project_id)
  end

  def show(conn, %{"id" => id, "project_id" => project_id}) do
    case Tasks.task_for_project(project_id, id) do
      %Task{} = task ->
        render(conn, "show.html", task: task)

      nil ->
        conn
        |> put_flash(:error, "Task not found.")
        |> redirect(to: project_task_path(conn, :index, project_id))
    end
  end

  def edit(conn, %{"id" => id, "project_id" => project_id}) do
    case Tasks.task_for_project(project_id, id) do
      %Task{} = task ->
        changeset = Task.changeset(task, %{})
        render(conn, "edit.html", task: task, changeset: changeset)

      nil ->
        conn
        |> put_flash(:error, "Task not found.")
        |> redirect(to: project_task_path(conn, :index, project_id))
    end
  end

  def update(conn, %{"task" => task_params, "id" => id, "project_id" => project_id}) do
    case Tasks.task_for_project(project_id, id) do
      %Task{} = task ->
        case Tasks.update_task(task, task_params) do
          {:ok, task} ->
            conn
            |> put_flash(:info, "#{task.name} updated successfully.")
            |> redirect(to: project_task_path(conn, :index, project_id))

          {:error, %Ecto.Changeset{} = changeset} ->
            render(conn, "edit.html", task: task, changeset: changeset)
        end

      nil ->
        conn
        |> put_flash(:error, "Task not found.")
        |> redirect(to: project_task_path(conn, :index, project_id))
    end
  end

  def new(conn, %{"project_id" => project_id}) do
    changeset = Tasks.new_task_changeset()
    render(conn, "new.html", changeset: changeset, project_id: project_id)
  end

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

  def authorize_project(conn, _opts) do
    current_user = conn.assigns[:current_user]
    project_id = conn.params["project_id"]

    case Projects.user_project(current_user.id, project_id) do
      %Project{} = project ->
        assign(conn, :project, project)

      nil ->
        conn
        |> put_flash(:error, "You are not authorized to see the page!")
        |> redirect(to: project_path(conn, :index))
        |> halt()
    end
  end
end
