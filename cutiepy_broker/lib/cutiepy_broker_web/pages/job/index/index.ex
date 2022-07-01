defmodule CutiepyBrokerWeb.Job.Index do
  use CutiepyBrokerWeb, :live_view

  def mount(_params, _session, socket) do
    :ok = Phoenix.PubSub.subscribe(CutiepyBroker.PubSub, "enqueued_job")
    jobs = CutiepyBroker.Queries.jobs()
    {:ok, assign(socket, jobs: jobs)}
  end

  def handle_info(%{event_type: "enqueued_job"}, socket) do
    jobs = CutiepyBroker.Queries.jobs()
    {:noreply, assign(socket, jobs: jobs)}
  end
end
