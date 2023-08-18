defmodule Jira.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
    add :name, :string
    add :description, :string
    add :status, :string
    add :project_id, references(:projects)
    
    timestamps()
  end
end
end
