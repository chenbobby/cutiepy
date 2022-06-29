defmodule CutiepyBrokerWeb.Job.Index do
  use CutiepyBrokerWeb, :live_view

  def mount(_params, _session, socket) do
    jobs = CutiepyBroker.Queries.jobs()
    :ok = Phoenix.PubSub.subscribe(CutiepyBroker.PubSub, "enqueued_job")
    {:ok, assign(socket, jobs: jobs)}
  end

  def handle_info(%{event_type: "enqueued_job"}, socket) do
    jobs = CutiepyBroker.Queries.jobs()
    {:noreply, assign(socket, jobs: jobs)}
  end

  def handle_event("redirect_to_job_show", %{"job_id" => job_id}, socket) do
    {:noreply,
     push_redirect(socket, to: Routes.live_path(socket, CutiepyBrokerWeb.Job.Show, job_id))}
  end
end
