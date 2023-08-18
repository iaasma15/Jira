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
  
    def link_to_task(%Task{id: id}) do
      # path = RumblWeb.Router.Helpers.user_path(conn, :create)
      Link.link("Show", to: "/tasks/#{id}")
    end
  
    # def edit_user_link(%User{id: id}) do
    #   # path = RumblWeb.Router.Helpers.user_path(conn, :create)
    #   Link.link("Edit", to: "/users/#{id}/edit")
    # end
  
    def delete_task_link(task) do
      Link.link("Delete", to: "/tasks/#{task.id}", method: :delete)
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
  