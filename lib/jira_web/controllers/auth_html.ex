defmodule JiraWeb.AuthHTML do
  use JiraWeb, :html
  import Phoenix.HTML.Form

  embed_templates "auth_html/*"
end
