defmodule Jira.Repo.Migrations.CreateUniqueUsers do
  use Ecto.Migration

  def change do
    create table("users") do
      add :name, :string
      add :pass_hash, :string
      add :login, :string, unique: true
     # timestamps()
    end
  end
end
