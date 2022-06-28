defmodule CutiepyBrokerWeb.JobsController do
  use CutiepyBrokerWeb, :controller

  def index(conn, _params) do
    jobs = CutiepyBroker.Queries.jobs()
    render(conn, "index.html", jobs: jobs)
  end
end
