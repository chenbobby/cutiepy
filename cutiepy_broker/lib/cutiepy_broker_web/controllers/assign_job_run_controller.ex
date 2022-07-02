defmodule CutiepyBrokerWeb.AssignJobRunController do
  use CutiepyBrokerWeb, :controller

  def create(conn, %{"worker_id" => worker_id}) do
    case CutiepyBroker.Commands.assign_job_run(%{worker_id: worker_id}) do
      {:ok, []} ->
        send_resp(conn, :no_content, "")

      {:ok, [assigned_job_run_event | _]} ->
        job_run_id = assigned_job_run_event.job_run_id
        job = CutiepyBroker.Queries.job(%{job_run_id: job_run_id})

        render(conn, "ok.json",
          job_run_id: job_run_id,
          job_function_key: job.function_key,
          job_args_serialized: job.args_serialized,
          job_kwargs_serialized: job.kwargs_serialized
        )
    end
  end
end
