defmodule CutiepyBrokerWeb.Jobs.Show do
  use CutiepyBrokerWeb, :live_view

  def mount(%{"job_id" => job_id}, _session, socket) do
    job = CutiepyBroker.Queries.job(job_id)
    {:ok, assign(socket, job: job)}
  end
end
