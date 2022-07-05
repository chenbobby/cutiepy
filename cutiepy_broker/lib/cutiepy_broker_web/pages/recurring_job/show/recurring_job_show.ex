defmodule CutiepyBrokerWeb.RecurringJobShow do
  use CutiepyBrokerWeb, :live_view

  def mount(%{"recurring_job_id" => recurring_job_id}, _session, socket) do
    case Ecto.UUID.cast(recurring_job_id) do
      {:ok, recurring_job_id} ->
        recurring_job = CutiepyBroker.Queries.recurring_job(%{recurring_job_id: recurring_job_id})
        events = CutiepyBroker.Queries.events(%{recurring_job_id: recurring_job_id})
        {:ok, assign(socket, recurring_job: recurring_job, events: events)}

      :error ->
        {:ok, assign(socket, recurring_job: nil)}
    end
  end
end
