defmodule JiraWeb.TaskController do
  use JiraWeb, :controller
  import Ecto.Query
  import Ecto.Repo
  alias Jira.Tasks
  alias Jira.Task
  alias Jira.Repo

  # plug :authenticate

  def index(conn, params) do
    tasks = Tasks.list_tasks(params)
    render(conn, "index.html", tasks: tasks)
  end

  def show(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)
    # |> Repo.preload(:project)
    render(conn, "task_description.html", task: task)
  end

  def new(conn, _params) do
    changeset = Tasks.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"task" => task_params}) do
    case Tasks.create_task(task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "#{task.name} created successfully.")
        |> redirect(to: JiraWeb.Router.Helpers.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    with %Task{} = task <- Tasks.get_task(id),
         {:ok, task} <- Tasks.delete_task(task) do
      conn
      |> put_flash(:info, "#{task.name} deleted successfully.")
      |> redirect(to: JiraWeb.Router.Helpers.task_path(conn, :index))
    else
      nil ->
        conn
        |> put_flash(:error, "Task not found.")
        |> redirect(to: JiraWeb.Router.Helpers.task_path(conn, :index))
    end
  end
end
