defmodule CutiepyBrokerWeb.CompleteJobRunController do
  use CutiepyBrokerWeb, :controller

  def create(
        conn,
        %{
          "job_run_id" => job_run_id,
          "job_run_result_serialized" => job_run_result_serialized,
          "job_run_result_repr" => job_run_result_repr,
          "worker_id" => worker_id
        }
      ) do
    case CutiepyBroker.Commands.complete_job_run(%{
           job_run_id: job_run_id,
           job_run_result_serialized: job_run_result_serialized,
           job_run_result_repr: job_run_result_repr,
           worker_id: worker_id
         }) do
      {:ok, event} ->
        render(conn, "ok.json", event: event)

      {:error, :job_run_timed_out} ->
        conn
        |> put_status(:conflict)
        |> render("conflict.json", error: :job_run_timed_out)
    end
  end
end
