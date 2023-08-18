defmodule Jira.Users do
    alias Jira.Repo
    alias Jira.User
    import Ecto.Query
    import Ecto.Changeset



    def list_users(params \\ %{}) do
        query = 
        if params["search"] do
            term = "%#{params["search"]}"

            from u in User,
             where: ilike(u.name, ^term) 
        else
            from u in User, order_by: [asc: u.id]
    end
    Repo.all(query)
end

    def change_user(%User{} = user) do
        User.changeset(user, %{})
    end

    def register(attrs) do
        %User{}
        |> User.registration_changeset(attrs)
        |> Repo.insert()
    end

    # def login(attrs) do
    #     case Repo.get_by(User, name: attrs["name"]) do
    #      %User{} = user ->
    #        if password_match?(user, attrs["pass_hash"]) do
    #          {:ok, user}
    #        else
    #          {:error, :username_and_password_does_not_match}
    #        end
    #      nil ->
    #        {:error, :user_not_found}
    #     end
    #    end

    #    def password_match?(user, pass_hash) do
    #       pass_hash == user.pass_hash
    #    end
     

    def get_user(id) do
        Repo.get(User, id)
    end

    def get_user_by(params) do
        Repo.get_by(User, params)
    end
    
    def create_user(attrs \\ %{}) do
        %User{}
        |> User.changeset(attrs)
        |> Repo.insert()
    end

    def update_user(user, attrs) do
        %User{}
        |> User.changeset(attrs)
        |> Repo.update()
    end

    def delete_user(user) do
       Repo.delete(user)
    end
end