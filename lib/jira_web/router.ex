defmodule JiraWeb.Router do
  use JiraWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {JiraWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", JiraWeb do
    pipe_through :browser

    get "/register", RegistrationController, :form
    post "/register", RegistrationController, :register
    get "/login", AuthController, :form
    post "/login", AuthController, :login

    get "/", PageController, :home
    resources "/users", UserController
    resources "/projects", ProjectController
    resources "/tasks", TaskController
    get "/task_description/:id", TaskController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", JiraWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:jira, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: JiraWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
