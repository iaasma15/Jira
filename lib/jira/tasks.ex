defmodule Jira.Tasks do
  alias Jira.Repo
  alias Jira.Task
  import Ecto.Query
  import Ecto.Changeset
  ## CRUDL

  def list_tasks(params \\ %{}) do
    query =
      if params["search"] do
        term = "%#{params["search"]}"

        from t in Task,
          where: ilike(t.name, ^term)
      else
        from t in Task, order_by: [asc: t.id]
      end

    Repo.all(query)
  end

  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end

  def get_project(id) do
    Repo.get(Project, id)
  end

  def get_task(id) do
    Repo.get(Task, id)
  end

  def get_task_by(params) do
    Repo.get_by(Task, params)
  end

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  # def update_project(project, attrs) do
  #     %User{}
  #     |> Project.changeset(attrs)
  #     |> Repo.update()
  # end

  def delete_task(task) do
    Repo.delete(task)
  end
end
