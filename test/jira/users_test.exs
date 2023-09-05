defmodule Jira.UsersTest do
  use Jira.DataCase
  alias Jira.Users

  describe "register/1" do
    test "success case" do
      attrs = %{
        "name" => "Anton",
        "login" => "anton",
        "password" => "test1234",
        "confirm_password" => "test1234"
      }

      {:ok, user} = Users.register(attrs)
      assert user.name == "Anton"
      assert user.login == "anton"

      assert user.pass_hash
      assert Bcrypt.verify_pass("test1234", user.pass_hash)
    end

    test "error case, login is too short" do
      attrs = %{
        "name" => "Anton",
        "login" => "an",
        "password" => "test1234",
        "confirm_password" => "test1234"
      }

      {:error, changeset} = Users.register(attrs)
      assert errors_on(changeset) == %{login: ["should be at least 3 character(s)"]}
    end

    test "error case, password and confirm_password don't match" do
      attrs = %{
        "name" => "Anton",
        "login" => "anton",
        "password" => "test1234",
        "confirm_password" => "test123478"
      }

      {:error, changeset} = Users.register(attrs)
      assert errors_on(changeset) == %{confirm_password: ["must match password"]}
    end

    test "error case, some fields are missing" do
      attrs = %{
        "name" => "",
        "login" => "anton",
        "password" => "test1234",
        "confirm_password" => "test1234"
      }

      {:error, changeset} = Users.register(attrs)
      assert errors_on(changeset) == %{name: ["can't be blank"]}
    end

    test "error case, login is already taken" do
      attrs = %{
        "name" => "Asma",
        "login" => "asma",
        "password" => "test1234",
        "confirm_password" => "test1234"
      }

      {:ok, _user} = Users.register(attrs)

      {:error, changeset} = Users.register(attrs)
      assert errors_on(changeset) == %{login: ["has already been taken"]}
    end
  end

  describe "login/1" do
    setup do
      attrs = %{
        "name" => "Asma",
        "login" => "asma",
        "password" => "test1234",
        "confirm_password" => "test1234"
      }

      {:ok, user} = Users.register(attrs)
      %{user: user}
    end

    test "success case" do
      assert {:ok, user} = Users.login(%{"login" => "asma", "password" => "test1234"})
      assert user.name == "Asma"
    end

    test "error case, incorrect password" do
      assert {:error, changeset} = Users.login(%{"login" => "asma", "password" => "1234"})
      assert errors_on(changeset) == %{password: ["doesn't match"]}
    end

    test "error case, user not found" do
      assert {:error, changeset} = Users.login(%{"login" => "anton", "password" => "1234"})
      assert errors_on(changeset) == %{login: ["no such user"]}
    end
  end
end
