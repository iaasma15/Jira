defmodule JiraWeb.ErrorHTMLTest do
  use JiraWeb.ConnCase, async: true

  # Bring render_to_string/4 for testing custom views
  import Phoenix.Template

  test "renders 404.html" do
    assert render_to_string(JiraWeb.ErrorHTML, "404", "html", []) =~
             "Sorry, the page you are looking for does not exist"
  end

  test "renders 500.html" do
    assert render_to_string(JiraWeb.ErrorHTML, "500", "html", []) =~
             "Sorry, Something went wrong."
  end
end
