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
        Link.link("Show", to: "/projects/#{id}")
      end

      # def edit_project_link(%Project{id: id}) do
      #   # path = RumblWeb.Router.Helpers.user_path(conn, :create)
      #   Link.link("Edit", to: "/projects/#{id}/edit")
      # end
    
      def delete_project_link(project) do
        Link.link("Delete", to: "/projects/#{project.id}", method: :delete)
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