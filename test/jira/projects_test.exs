defmodule Jira.ProjectsTest do
  use Jira.DataCase
  alias Jira.Projects
  alias Jira.Users

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

  describe "create_project/1" do
    test "create_project/1", %{user: user} do
      assert {:ok, _project} =
               Projects.create_project(%{
                 "name" => "metal",
                 "description" => "ghjk",
                 "user_id" => user.id
               })
    end

    test "error case, no user_id" do
      assert {:error, changeset} = Projects.create_project(%{"name" => "metal"})
      assert errors_on(changeset) == %{user_id: ["can't be blank"]}
    end

    test "error case, name length validation", %{user: user} do
      assert {:error, changeset} =
               Projects.create_project(%{"name" => "aa", "user_id" => user.id})

      assert errors_on(changeset) == %{name: ["should be at least 3 character(s)"]}
    end
  end

  describe "user_projects/2" do
    setup %{user: user} do
      # create a couple of projects
      {:ok, _project} =
        Projects.create_project(%{
          "name" => "diamond",
          "description" => "fghjkvb",
          "user_id" => user.id
        })

      {:ok, _project} =
        Projects.create_project(%{
          "name" => "diamond1",
          "description" => "fghjkvb",
          "user_id" => user.id
        })

      {:ok, _project} =
        Projects.create_project(%{
          "name" => "diamond11",
          "description" => "dhjk",
          "user_id" => user.id
        })

      :ok
    end

    test "show all for user", %{user: user} do
      projects = Projects.user_projects(user.id, nil)
      assert length(projects) == 3

      projects = Projects.user_projects(user.id, "")
      assert length(projects) == 3
    end

    test "when search_term is provided", %{user: user} do
      projects = Projects.user_projects(user.id, "aMond")
      assert length(projects) == 3

      projects = Projects.user_projects(user.id, "diamond1")
      assert length(projects) == 2
    end

    test "update_project", %{user: user} do
      {:ok, project} =
        Projects.create_project(%{
          "name" => "diamond11",
          "description" => "dhjk",
          "user_id" => user.id
        })

      {:ok, project} =
        Projects.update_project(project, %{
          "name" => "diamond",
          "description" => "star",
          "user_id" => user.id
        })

      assert project.name == "diamond"
      assert project.description == "star"
    end

    test "error case, update when name is nil", %{user: user} do
      {:ok, project} =
        Projects.create_project(%{
          "name" => "diamond11",
          "description" => "dhjk",
          "user_id" => user.id
        })

      assert {:error, _error} = Projects.update_project(project, %{name: nil, description: "te"})
    end
  end
end
