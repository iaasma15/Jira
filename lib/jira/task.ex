defmodule Jira.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :description, :string
    field :status, :string # it should be enum - todo, in_progress, done

    belongs_to :project, Jira.Project

    timestamps()
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :status, :project_id])
    |> validate_required([:project_id, :name])
    # validate that status has one of correct values
    |> validate_length(:name, min: 3, max: 50)
  end
end
