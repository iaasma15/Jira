defmodule Jira.Repo do
  use Ecto.Repo,
    otp_app: :jira,
    adapter: Ecto.Adapters.Postgres
end
