defmodule JiraWeb.AuthControllerTest do
  use JiraWeb.ConnCase
  alias Jira.Users

  test "GET /login", %{conn: conn} do
    conn = get(conn, ~p"/login")

    assert html_response(conn, 200) =~ "form action=\"/login\""
    assert html_response(conn, 200) =~ "Login"
  end

  describe "POST /login" do
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

    test "success login", %{conn: conn} do
      conn = post(conn, ~p"/login", %{"user" => %{"login" => "asma", "password" => "test1234"}})
      assert conn.assigns[:flash] == %{"info" => "Asma login successfully."}
      assert conn.status == 302
      assert Enum.member?(conn.resp_headers, {"location", "/projects"})
    end

    test "error case", %{conn: conn} do
      conn = post(conn, ~p"/login", %{"user" => %{"login" => "asma", "password" => "test"}})
      assert html_response(conn, 200) =~ "form action=\"/login\""
      assert html_response(conn, 200) =~ "Login and Password does not match"
    end
  end
end
