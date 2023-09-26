defmodule Jira.Task do
  use Ecto.Schema
  import Ecto.Changeset

  @statuses [:todo, :in_progress, :done]

  schema "tasks" do
    field :name, :string
    field :description, :string
    field :status, Ecto.Enum, values: @statuses

    belongs_to :project, Jira.Project

    timestamps()
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :status, :project_id])
    |> validate_required([:project_id, :name, :status])
    |> validate_inclusion(:status, @statuses)
    |> validate_length(:name, min: 3, max: 50)
  end
end
