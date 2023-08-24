defmodule Jira.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :login, :string
    field :pass_hash, :string

    field :password, :string, virtual: true
    field :confirm_password, :string, virtual: true

    has_many :projects, Jira.Project

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :pass_hash, :login])
    |> unique_constraint(:login)
    |> validate_length(:name, min: 3, max: 10)
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :login, :password, :confirm_password])
    |> validate_required([:name, :login, :password, :confirm_password])
    |> set_pass_hash()
    |> unique_constraint(:login)
    |> validate_length(:login, min: 3, max: 10)
    |> validate_length(:password, min: 6)
    |> validate_password_or_confirm_password()
  end

  def set_pass_hash(changeset) do
    password = get_change(changeset, :password)

    if password do
      hash = Bcrypt.hash_pwd_salt(password)
      put_change(changeset, :pass_hash, hash)
    else
      changeset
    end
  end

  defp validate_password_or_confirm_password(changeset) do
    password = get_change(changeset, :password)
    confirm_password = get_change(changeset, :confirm_password)

    if password || confirm_password do
      if password != confirm_password do
        add_error(changeset, :confirm_password, "must match password")
      else
        changeset
      end
    else
      add_error(changeset, :password, "or confirm_password must be present")
    end
  end
end
