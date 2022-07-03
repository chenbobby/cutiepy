defmodule CutiepyBrokerWeb.ScheduledJobShow do
  use CutiepyBrokerWeb, :live_view

  def mount(%{"scheduled_job_id" => scheduled_job_id}, _session, socket) do
    case Ecto.UUID.cast(scheduled_job_id) do
      {:ok, scheduled_job_id} ->
        scheduled_job = CutiepyBroker.Queries.scheduled_job(%{scheduled_job_id: scheduled_job_id})
        events = CutiepyBroker.Queries.events(%{scheduled_job_id: scheduled_job_id})
        {:ok, assign(socket, scheduled_job: scheduled_job, events: events)}

      :error ->
        {:ok, assign(socket, scheduled_job: nil)}
    end
  end
end
