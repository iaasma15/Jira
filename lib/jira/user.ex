defmodule Jira.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :pass_hash, :string
    field :login, :string
    has_many :projects, Jira.Project

    timestamps()
  end
def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :pass_hash, :login])
   # |> validate_unique(:login)
    |> unique_constraint(:login)
    |> validate_length(:name, min: 3, max: 10)
end

def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :pass_hash])
    |> validate_required([:name, :pass_hash])
    |> unique_constraint(:name)
    |> unique_constraint(:login)
    |> validate_length(:name, min: 3, max: 10)
    |> validate_length(:pass_hash, min: 6)
end
end