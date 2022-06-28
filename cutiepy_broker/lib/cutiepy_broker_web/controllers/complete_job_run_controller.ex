defmodule CutiepyBrokerWeb.CompleteJobRunController do
  use CutiepyBrokerWeb, :controller

  def create(
        conn,
        %{
          "job_run_id" => _,
          "job_run_result_serialized" => _,
          "worker_id" => _
        } = params
      ) do
    {:ok, event} = CutiepyBroker.Commands.complete_job_run(params)
    render(conn, "response.json", event: event)
  end
end
