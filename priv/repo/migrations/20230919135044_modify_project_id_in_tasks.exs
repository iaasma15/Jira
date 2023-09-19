defmodule Jira.Repo.Migrations.ModifyProjectIdInTasks do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE tasks DROP CONSTRAINT tasks_project_id_fkey"

    alter table("tasks") do
      modify :project_id, references(:projects, on_delete: :delete_all)
    end
  end

  def down do
    execute "ALTER TABLE tasks DROP CONSTRAINT tasks_project_id_fkey"

    alter table("tasks") do
      modify :project_id, references(:projects)
    end
  end
end
