defmodule JiraWeb.RegistrationHTML do
  use JiraWeb, :html
  alias Jira.User
  alias Phoenix.HTML.Link
  import Phoenix.HTML.Form

  embed_templates "registration_html/*"
end
