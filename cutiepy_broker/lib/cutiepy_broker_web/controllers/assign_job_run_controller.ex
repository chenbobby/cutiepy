defmodule CutiepyBrokerWeb.AssignJobRunController do
  use CutiepyBrokerWeb, :controller

  def create(conn, %{"worker" => %{"id" => worker_id}}) do
    case CutiepyBroker.Commands.assign_job_run(%{worker_id: worker_id}) do
      {:ok, job_run_id, job} ->
        render(conn, "assigned.json", job_run_id: job_run_id, job: job)

      {:ok, nil} ->
        render(conn, "no_jobs.json")
    end
  end
end
