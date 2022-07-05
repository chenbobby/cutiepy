defmodule CutiepyBrokerWeb.RecurringJobIndex do
  use CutiepyBrokerWeb, :live_view

  def mount(_params, _session, socket) do
    :ok = Phoenix.PubSub.subscribe(CutiepyBroker.PubSub, "created_recurring_job")
    recurring_jobs = CutiepyBroker.Queries.recurring_jobs()
    {:ok, assign(socket, recurring_jobs: recurring_jobs)}
  end

  def handle_info(%{event_type: "created_recurring_job"}, socket) do
    recurring_jobs = CutiepyBroker.Queries.recurring_jobs()
    {:noreply, assign(socket, recurring_jobs: recurring_jobs)}
  end
end
