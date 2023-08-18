defmodule Jira.Project do
    use Ecto.Schema
    import Ecto.Changeset
  
    schema "projects" do
      field :name, :string
      field :deadline, :date
      field :description, :string
      belongs_to :user, Jira.User
      has_one :task, Jira.Task
     # timestamps()
    end

    def changeset(project, attrs) do
        project
        |> cast(attrs, [:name, :deadline, :description, :user_id])
       # |> validate_unique(:login)
        #|> unique_constraint(:login)
        |> validate_length(:name, min: 3, max: 10)
    end
    
end