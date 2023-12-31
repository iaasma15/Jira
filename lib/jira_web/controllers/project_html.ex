defmodule JiraWeb.ProjectHTML do
  use JiraWeb, :html
  alias Jira.Project
  alias Phoenix.HTML.Link
  import Phoenix.HTML.Form

  embed_templates "project_html/*"

  def first_name(%Project{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end

  def link_to_project(%Project{id: id}) do
    # path = RumblWeb.Router.Helpers.user_path(conn, :create)
    Link.link("Show", to: "/projects/#{id}/tasks")
  end

  def update_project_link(%Project{id: id}) do
    # path = RumblWeb.Router.Helpers.user_path(conn, :create)
    Link.link("Edit", to: "/projects/#{id}/edit")
  end

  def delete_project_link(project) do
    Link.link("Delete", to: "/projects/#{project.id}", method: :delete)
  end
end
