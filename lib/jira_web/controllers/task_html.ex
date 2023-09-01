defmodule JiraWeb.TaskHTML do
  use JiraWeb, :html
  alias Jira.Task
  alias Phoenix.HTML.Link
  import Phoenix.HTML.Form

  embed_templates "task_html/*"

  def first_name(%Task{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end

  def link_to_new_task(project_id) do
    Link.link("Add new task", to: "/projects/#{project_id}/tasks/new")
  end

  def link_to_task(conn, id) do
    project_id = conn.assigns[:project_id]
    Link.link("Show", to: project_task_path(conn, :show, project_id, id))
  end

  # def edit_user_link(%User{id: id}) do
  #   # path = RumblWeb.Router.Helpers.user_path(conn, :create)
  #   Link.link("Edit", to: "/users/#{id}/edit")
  # end

  def delete_task_link(conn, id) do
    project_id = conn.assigns[:project_id]
    Link.link("Delete", to: project_task_path(conn, :delete, project_id, id), method: :delete)
  end
end
