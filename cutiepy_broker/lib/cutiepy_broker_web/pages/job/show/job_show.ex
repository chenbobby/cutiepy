defmodule CutiepyBrokerWeb.JobShow do
  use CutiepyBrokerWeb, :live_view

  def mount(%{"job_id" => job_id}, _session, socket) do
    case Ecto.UUID.cast(job_id) do
      {:ok, job_id} ->
        job = CutiepyBroker.Queries.job(%{job_id: job_id})
        job_runs = CutiepyBroker.Queries.job_runs(%{job_id: job_id})
        events = CutiepyBroker.Queries.events(%{job_id: job_id})
        {:ok, assign(socket, job: job, job_runs: job_runs, events: events)}

      :error ->
        {:ok, assign(socket, job: nil)}
    end
  end
end
