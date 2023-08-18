defmodule JiraWeb.UserHTML do
  use JiraWeb, :html
  alias Jira.User
  alias Phoenix.HTML.Link
  import Phoenix.HTML.Form

  embed_templates "user_html/*"

  def first_name(%User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end

  def link_to_user(%User{id: id}) do
    # path = RumblWeb.Router.Helpers.user_path(conn, :create)
    Link.link("Show", to: "/users/#{id}")
  end

  def edit_user_link(%User{id: id}) do
    # path = RumblWeb.Router.Helpers.user_path(conn, :create)
    Link.link("Edit", to: "/users/#{id}/edit")
  end

  def delete_user_link(user) do
    Link.link("Delete", to: "/users/#{user.id}", method: :delete)
  end

  def error_message(changeset) do
    changeset.errors
    |> Enum.map(fn {attr, {msg, _}} ->
      "#{attr} : #{msg}"
    end)
    |> Enum.join(". ")
  end

  def render("form.html", assigns) do
  end
end
