defmodule Jira.Repo.Migrations.TasksBelongsToProjects do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :project_id, references(:projects)
    end

  end
end
