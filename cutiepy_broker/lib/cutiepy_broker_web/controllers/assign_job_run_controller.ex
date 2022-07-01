defmodule CutiepyBrokerWeb.AssignJobRunController do
  use CutiepyBrokerWeb, :controller

  def create(conn, %{"worker_id" => worker_id}) do
    case CutiepyBroker.Commands.assign_job_run(%{worker_id: worker_id}) do
      {:ok, []} ->
        send_resp(conn, :no_content, "")

      {:ok, [assigned_job_run_event | _]} ->
        render(conn, "ok.json", event: assigned_job_run_event)
    end
  end
end
