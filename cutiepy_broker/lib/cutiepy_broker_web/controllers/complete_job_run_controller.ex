defmodule CutiepyBrokerWeb.CompleteJobRunController do
  use CutiepyBrokerWeb, :controller

  def create(
        conn,
        %{
          "job_run_id" => _,
          "job_run_result_serialized" => _,
          "job_run_result_repr" => _,
          "worker_id" => _
        } = params
      ) do
    case CutiepyBroker.Commands.complete_job_run(params) do
      {:ok, event} ->
        render(conn, "ok.json", event: event)

      {:error, :job_run_timed_out} ->
        conn
        |> put_status(:conflict)
        |> render("conflict.json", error: :job_run_timed_out)
    end
  end
end
