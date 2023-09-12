defmodule JiraWeb.ProjectControllerTest do
  use JiraWeb.ConnCase
  alias Jira.Projects
  alias Jira.Users

  setup %{conn: conn} do
    attrs = %{
      "name" => "Asma",
      "login" => "asma",
      "password" => "test1234",
      "confirm_password" => "test1234"
    }

    {:ok, user} = Users.register(attrs)

    conn =
      conn
      |> fetch_session()
      |> put_session(:current_user, user)

    %{conn: conn, user: user}
  end

  describe "GET /projects" do
    setup %{user: user} do
      {:ok, project1} =
        Projects.create_project(%{
          "name" => "asma",
          "description" => "fghjkvb",
          "user_id" => user.id
        })

      {:ok, project2} =
        Projects.create_project(%{
          "name" => "anton",
          "description" => "fghjkvb",
          "user_id" => user.id
        })

      %{project1: project1, project2: project2}
    end

    test "GET /projects", %{conn: conn, project1: project1, project2: project2} do
      conn = get(conn, ~p"/projects")

      assert html_response(conn, 200) =~ "Current Project List"
      assert html_response(conn, 200) =~ project1.name
      assert html_response(conn, 200) =~ project2.name
    end

    test "GET /projects with search parameter", %{
      conn: conn,
      project1: project1,
      project2: project2
    } do
      conn = get(conn, ~p"/projects", %{"search" => "asm"})
      assert html_response(conn, 200) =~ project1.name
      refute html_response(conn, 200) =~ project2.name
    end
  end

  # TODO alll the other actions

  describe "POST /projects" do
    test "success case", %{conn: conn} do
      attr = %{
        "name" => "Asma project"
      }

      resp = post(conn, ~p"/projects", %{"project" => attr})

      assert resp.status == 302
      assert Enum.member?(resp.resp_headers, {"location", "/projects"})
      assert resp.assigns[:flash] == %{"info" => "Asma project created successfully."}
      resp = get(conn, ~p"/projects")
      assert html_response(resp, 200) =~ "Asma project"
    end
  end

  describe "PUT /projects/:id" do
    setup %{user: user} do
      {:ok, project} =
        Projects.create_project(%{
          "name" => "asma",
          "description" => "fghjkvb",
          "user_id" => user.id
        })

      %{project: project}
    end

    test "success case", %{conn: conn, project: project} do
      attr = %{"name" => "Anton Project", "description" => "qwert"}

      resp = put(conn, ~p"/projects/#{project.id}", %{"project" => attr})
      assert resp.status == 302

      resp = get(conn, ~p"/projects")
      assert html_response(resp, 200) =~ "Anton Project"
    end
  end
end
