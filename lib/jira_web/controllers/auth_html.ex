defmodule JiraWeb.AuthHTML do
  use JiraWeb, :html
  alias Jira.User
  alias Phoenix.HTML.Link
  import Phoenix.HTML.Form

  embed_templates "auth_html/*"
end
