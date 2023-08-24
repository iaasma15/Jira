defmodule Jira.Repo.Migrations.AddUniqueIndexUsersTable do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:login])
  end
end
