defmodule CutiepyBrokerWeb.CompleteJobRunController do
  use CutiepyBrokerWeb, :controller

  def create(
        conn,
        %{
          "job_run" =>
            %{
              "job_run_id" => _,
              "worker_id" => _,
              "result_serialized" => _
            } = job_run_params
        }
      ) do
    :ok = CutiepyBroker.Commands.complete_job_run(job_run_params)

    render(conn, "completed.json")
  end
end
