defmodule Jira.Projects do
    alias Jira.Repo
    alias Jira.Project
    import Ecto.Query
    import Ecto.Changeset
##CRUDL


    def list_projects(params \\ %{}) do
        query = 
        if params["search"] do
            term = "%#{params["search"]}"

            from p in Project,
             where: ilike(p.name, ^term) 
        else
            from p in Project, order_by: [asc: p.id]
    end
    Repo.all(query)
end

    def change_project(%Project{} = project) do
        Project.changeset(project, %{})
    end


    def get_user(id) do
        Repo.get(User, id)
    end

    
    def get_project(id) do
        Repo.get(Project, id)
    end

    def get_project_by(params) do
        Repo.get_by(Project, params)
    end
    
    def create_project(attrs \\ %{}) do
        %Project{}
        |> Project.changeset(attrs)
        |> Repo.insert()
    end

    # def update_project(project, attrs) do
    #     %User{}
    #     |> Project.changeset(attrs)
    #     |> Repo.update()
    # end

    def delete_project(project) do
       Repo.delete(project)
    end
end
