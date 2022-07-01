defmodule CutiepyBrokerWeb.Event.Index do
  use CutiepyBrokerWeb, :live_view

  def mount(_params, _session, socket) do
    :ok = Phoenix.PubSub.subscribe(CutiepyBroker.PubSub, "*")
    events = CutiepyBroker.Queries.events()
    {:ok, assign(socket, events: events)}
  end

  def handle_info(%{event_type: _}, socket) do
    events = CutiepyBroker.Queries.events()
    {:ok, assign(socket, events: events)}
  end
end
