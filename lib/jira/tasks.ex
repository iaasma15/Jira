defmodule Jira.Tasks do
  alias Jira.Repo
  alias Jira.Task
  import Ecto.Query
  import Ecto.Changeset
  ## CRUDL

  def project_tasks(project_id, search_term) do
    query =
      if String.length("#{search_term}") > 0 do
        term = "%#{search_term}%"

        from t in Task,
          where: t.project_id == ^project_id,
          where: ilike(t.name, ^term)
      else
        from t in Task,
          where: t.project_id == ^project_id,
          order_by: [asc: t.id]
      end

    Repo.all(query)
  end

  def new_task_changeset() do
    change(%Task{}, %{})
  end

  def get_project(id) do
    Repo.get(Project, id)
  end

  def get_task(id) do
    Repo.get(Task, id)
  end

  def task_for_project(project_id, task_id) do
    query =
      from t in Task,
        where: t.id == ^task_id,
        where: t.project_id == ^project_id

    Repo.one(query)
  end

  def get_task_by(params) do
    Repo.get_by(Task, params)
  end

  def create_task(attrs \\ %{}) do
    %Task{}
    |> Task.changeset(attrs)
    |> Repo.insert()
  end

  def update_task(task, attrs) do
    task
    |> Task.changeset(attrs)
    |> Repo.update()
  end

  def delete_task(task) do
    Repo.delete(task)
  end
end
