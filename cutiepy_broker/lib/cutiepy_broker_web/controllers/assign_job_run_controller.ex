defmodule CutiepyBrokerWeb.AssignJobRunController do
  use CutiepyBrokerWeb, :controller

  def create(conn, %{"worker_id" => _} = params) do
    {:ok, event} = CutiepyBroker.Commands.assign_job_run(params)
    render(conn, "response.json", event: event)
  end
end
