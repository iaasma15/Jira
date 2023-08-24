defmodule Jira.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :description, :string
    field :status, :string

    belongs_to :project, Jira.Project

    timestamps()
  end

  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :description, :status, :project_id])
    # |> validate_unique(:login)
    # |> unique_constraint(:login)
    |> validate_length(:name, min: 3, max: 10)

    #  |> Repo.preload(:project)
  end
end
