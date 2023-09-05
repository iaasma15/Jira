defmodule JiraWeb.RegistrationControllerTest do
  use JiraWeb.ConnCase

  test "GET /register", %{conn: conn} do
    conn = get(conn, ~p"/register")

    assert html_response(conn, 200) =~ "Register"
    assert html_response(conn, 200) =~ "form action=\"/register\""
    assert html_response(conn, 200) =~ "Login:"
  end

  describe "POST /register" do
    test "success case", %{conn: conn} do
      attr = %{
        "name" => "Anton",
        "login" => "anton",
        "password" => "test1234",
        "confirm_password" => "test1234"
      }

      conn = post(conn, ~p"/register", %{"user" => attr})

      assert conn.status == 302
      assert Enum.member?(conn.resp_headers, {"location", "/login"})
      assert conn.assigns[:flash] == %{"info" => "Anton registered successfully."}
    end

    test "error case", %{conn: conn} do
      attr = %{
        "name" => "",
        "login" => "",
        "password" => "",
        "confirm_password" => ""
      }

      conn = post(conn, ~p"/register", %{"user" => attr})

      assert html_response(conn, 200) =~ "form action=\"/register\""
      assert html_response(conn, 200) =~ "be blank"
    end
  end
end
