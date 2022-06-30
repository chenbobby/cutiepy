defmodule CutiepyBrokerWeb.Job.Show do
  use CutiepyBrokerWeb, :live_view

  def mount(%{"job_id" => job_id}, _session, socket) do
    job = CutiepyBroker.Queries.job(%{job_id: job_id})
    job_runs = CutiepyBroker.Queries.job_runs(%{job_id: job_id})
    {:ok, assign(socket, job: job, job_runs: job_runs)}
  end
end
