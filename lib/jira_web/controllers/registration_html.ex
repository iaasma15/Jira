defmodule JiraWeb.RegistrationHTML do
  use JiraWeb, :html
  alias Jira.User
  alias Phoenix.HTML.Link
  import Phoenix.HTML.Form

  embed_templates "registration_html/*"

  def error_message(changeset) do
    changeset.errors
    |> Enum.map(fn {attr, {msg, _}} ->
      "#{attr} : #{msg}"
    end)
    |> Enum.join(". ")
  end
end
