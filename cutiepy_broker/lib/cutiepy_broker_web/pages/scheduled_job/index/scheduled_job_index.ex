defmodule CutiepyBrokerWeb.ScheduledJobIndex do
  use CutiepyBrokerWeb, :live_view

  def mount(_params, _session, socket) do
    :ok = Phoenix.PubSub.subscribe(CutiepyBroker.PubSub, "created_scheduled_job")
    scheduled_jobs = CutiepyBroker.Queries.scheduled_jobs()
    {:ok, assign(socket, scheduled_jobs: scheduled_jobs)}
  end

  def handle_info(%{event_type: "created_scheduled_job"}, socket) do
    jobs = CutiepyBroker.Queries.jobs()
    {:noreply, assign(socket, jobs: jobs)}
  end
end
