defmodule CutiepyBrokerWeb.RegisterWorkerController do
  use CutiepyBrokerWeb, :controller

  def create(conn, _params) do
    case CutiepyBroker.Commands.register_worker(%{}) do
      {:ok, [registered_worker_event | _]} ->
        render(conn, "ok.json", event: registered_worker_event)
    end
  end
end
