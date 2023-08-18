defmodule Jira.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table("projects") do
      add :name, :string
      add :description, :string
      add :user_id, references(:users)
      
      timestamps()
    end
  end
end
