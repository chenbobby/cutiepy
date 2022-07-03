defmodule CutiepyBrokerWeb.Router do
  use CutiepyBrokerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CutiepyBrokerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CutiepyBrokerWeb do
    pipe_through :browser

    get "/", HomePageController, :index
    live "/events", Event.Index
    live "/jobs", Job.Index
    live "/jobs/:job_id", Job.Show
    live "/workers", Worker.Index
  end

  scope "/api", CutiepyBrokerWeb do
    pipe_through :api

    post "/assign_job_run", AssignJobRunController, :create
    post "/complete_job_run", CompleteJobRunController, :create
    post "/create_scheduled_job", CreateScheduledJobController, :create
    post "/create_repeating_job", CreateRepeatingJobController, :create
    post "/enqueue_job", EnqueueJobController, :create
    post "/register_worker", RegisterWorkerController, :create
    post "/fail_job_run", FailJobRunController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", CutiepyBrokerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/_dashboard", metrics: CutiepyBrokerWeb.Telemetry
    end
  end
end
