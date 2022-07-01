defmodule CutiepyBrokerWeb.Worker.Index do
  use CutiepyBrokerWeb, :live_view

  def mount(_params, _session, socket) do
    :ok = Phoenix.PubSub.subscribe(CutiepyBroker.PubSub, "registered_worker")
    workers = CutiepyBroker.Queries.workers()
    {:ok, assign(socket, workers: workers)}
  end

  def handle_info(%{event_type: "registered_worker"}, socket) do
    workers = CutiepyBroker.Queries.workers()
    {:noreply, assign(socket, workers: workers)}
  end
end
