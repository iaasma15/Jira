defmodule Jira.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
    add :name, :string
    add :description, :string
    add :status, :string
    
    timestamps()
  end
end
end
