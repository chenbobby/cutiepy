defmodule CutiepyBrokerWeb.FailJobRunController do
  use CutiepyBrokerWeb, :controller

  def create(conn, %{
        "job_run_id" => job_run_id,
        "job_run_error_serialized" => job_run_error_serialized,
        "job_run_error_repr" => job_run_error_repr,
        "worker_id" => worker_id
      }) do
    case CutiepyBroker.Commands.fail_job_run(%{
           job_run_id: job_run_id,
           job_run_error_serialized: job_run_error_serialized,
           job_run_error_repr: job_run_error_repr,
           worker_id: worker_id
         }) do
      {:ok, [failed_job_run_event | _]} ->
        render(conn, "ok.json", event: failed_job_run_event)

      {:error, :job_run_timed_out} ->
        conn
        |> put_status(:conflict)
        |> render("conflict.json", error: :job_run_timed_out)
    end
  end
end
