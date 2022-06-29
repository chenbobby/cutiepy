defmodule CutiepyBrokerWeb.AssignJobRunController do
  use CutiepyBrokerWeb, :controller

  def create(conn, %{"worker_id" => _} = params) do
    case CutiepyBroker.Commands.assign_job_run(params) do
      {:ok, nil} ->
        send_resp(conn, :no_content, "")

      {:ok, event} ->
        render(conn, "ok.json", event: event)
    end
  end
end
