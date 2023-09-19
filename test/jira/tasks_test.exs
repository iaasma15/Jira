defmodule Jira.TasksTest do
  use Jira.DataCase
  alias Jira.Tasks
  alias Jira.Projects
  alias Jira.Users

  setup do
    user_attrs = %{
      "name" => "Asma",
      "login" => "asma",
      "password" => "test1234",
      "confirm_password" => "test1234"
    }

    {:ok, user} = Users.register(user_attrs)

    project_attrs = %{
      "name" => "Project1",
      "user_id" => user.id
    }

    {:ok, project} = Projects.create_project(project_attrs)

    %{user: user, project: project}
  end

  describe "create_task/1" do
    test "create_task/1", %{project: project} do
      assert {:ok, _task} =
               Tasks.create_task(%{
                 "name" => "metal",
                 "description" => "ghjk",
                 "project_id" => project.id,
                 "status" => "done"
               })
    end

    test "error case, no project_id" do
      assert {:error, changeset} = Tasks.create_task(%{"name" => "metal"})
      assert errors_on(changeset) == %{project_id: ["can't be blank"]}
    end

    test "error case, no task_name", %{project: project} do
      assert {:error, changeset} = Tasks.create_task(%{"project_id" => project.id})
      assert errors_on(changeset) == %{name: ["can't be blank"]}
    end

    test "error case, name length validation", %{project: project} do
      assert {:error, changeset} =
               Tasks.create_task(%{"name" => "aa", "project_id" => project.id})

      assert errors_on(changeset) == %{name: ["should be at least 3 character(s)"]}
    end
  end

  describe "task_for_project(project_id, task_id)" do
    setup %{project: project} do
      {:ok, task} =
        Tasks.create_task(%{
          "name" => "metal",
          "description" => "ghjk",
          "project_id" => project.id,
          "status" => "done"
        })

      %{task: task}
    end

    test "success case", %{project: project, task: task} do
      found = Tasks.task_for_project(project.id, task.id)
      assert found.id == task.id
    end
  end

  describe "project_tasks/2" do
    setup %{project: project} do
      {:ok, _task} =
        Tasks.create_task(%{
          "name" => "react",
          "description" => "fghjkvb",
          "project_id" => project.id
        })

      {:ok, _task} =
        Tasks.create_task(%{
          "name" => "react1",
          "description" => "fghjkvb",
          "project_id" => project.id
        })

      {:ok, _task} =
        Tasks.create_task(%{
          "name" => "react",
          "description" => "fghjkvb",
          "project_id" => project.id
        })

      :ok
    end

    test "show all projects", %{project: project} do
      projects = Tasks.project_tasks(project.id, nil)
      assert length(projects) == 3

      projects = Tasks.project_tasks(project.id, "")
      assert length(projects) == 3
    end

    test "when search_term is provided", %{project: project} do
      projects = Tasks.project_tasks(project.id, "ReAct")
      assert length(projects) == 3
      projects = Tasks.project_tasks(project.id, "reaCT1")
      assert length(projects) == 1
    end
  end

  describe "update_task/2" do
    setup %{project: project} do
      {:ok, task} =
        Tasks.create_task(%{
          "name" => "react",
          "description" => "fghjkvb",
          "project_id" => project.id
        })

      %{task: task}
    end

    test "success case", %{project: project, task: task} do
      {:ok, task} =
        Tasks.update_task(task, %{
          "name" => "diamond",
          "description" => "star",
          "project_id" => project.id,
          "status" => "not active"
        })

      assert task.name == "diamond"
      assert task.description == "star"
    end

    test "error case, update when name is nil", %{project: project} do
      {:ok, task} =
        Tasks.create_task(%{
          "name" => "diamond",
          "description" => "star",
          "project_id" => project.id
        })

      assert {:error, _error} = Tasks.update_task(task, %{name: nil, description: "te"})
    end
  end
end
