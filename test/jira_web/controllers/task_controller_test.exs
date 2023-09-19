defmodule JiraWeb.TaskControllerTest do
  use JiraWeb.ConnCase
  alias Jira.Projects
  alias Jira.Tasks
  alias Jira.Users
  alias JiraWeb.Router.Helpers, as: Routes

  setup %{conn: conn} do
    attrs = %{
      "name" => "Asma",
      "login" => "asma",
      "password" => "test1234",
      "confirm_password" => "test1234"
    }

    {:ok, user} = Users.register(attrs)

    {:ok, project} =
      Projects.create_project(%{
        "name" => "asma",
        "description" => "fghjkvb",
        "user_id" => user.id
      })

    conn =
      conn
      |> fetch_session()
      |> put_session(:current_user, user)

    %{conn: conn, user: user, project: project}
  end

  describe "GET /tasks" do
    setup %{project: project} do
      {:ok, task} =
        Tasks.create_task(%{
          "name" => "metal",
          "description" => "hello",
          "project_id" => project.id
        })

      %{task: task}
    end

    test "GET /tasks", %{conn: conn, project: project, task: task} do
      tasks_url = Routes.project_task_path(conn, :index, project)
      conn = get(conn, tasks_url)
      assert conn.status == 200
      assert html_response(conn, 200) =~ "Task List"
      assert html_response(conn, 200) =~ task.name
    end

    test "GET /tasks with search parameter", %{
      conn: conn,
      project: project,
      task: task
    } do
      {:ok, another_task} = Tasks.create_task(%{"name" => "steel", "project_id" => project.id})

      tasks_url = Routes.project_task_path(conn, :index, project)
      conn = get(conn, tasks_url, %{"search" => "steel"})

      assert html_response(conn, 200) =~ another_task.name
      refute html_response(conn, 200) =~ task.name
    end
  end

  describe "POST /tasks" do
    test "success case", %{conn: conn, project: project} do
      attr = %{
        "name" => "Asma task",
        "description" => "vbn"
      }

      tasks_url = Routes.project_task_path(conn, :create, project)
      conn = post(conn, tasks_url, %{"task" => attr})
      assert conn.assigns[:flash] == %{"info" => "Asma task created successfully."}
      assert conn.status == 302
    end

    test "error case, when name is empty", %{conn: conn, project: project} do
      attr = %{
        "name" => "As",
        "description" => "vbn"
      }

      tasks_url = Routes.project_task_path(conn, :create, project)
      conn = post(conn, tasks_url, %{"task" => attr})
      assert conn.status == 200
      assert length(conn.assigns[:changeset].errors) > 0
    end
  end

  describe "PUT /tasks/:id" do
    setup %{project: project} do
      {:ok, task} =
        Tasks.create_task(%{
          "name" => "metal",
          "description" => "hello",
          "project_id" => project.id
        })

      %{task: task}
    end

    test "success case", %{conn: conn, project: project, task: task} do
      attr = %{"name" => "Anton Project", "description" => "qwert"}

      resp = put(conn, ~p"/projects/#{project.id}/tasks/#{task.id}", %{"task" => attr})
      assert resp.status == 302

      resp = get(conn, ~p"/projects/#{project.id}/tasks")
      assert html_response(resp, 200) =~ "Anton Project"
    end
  end
end
