defmodule CutiepyBrokerWeb.EnqueueJobController do
  use CutiepyBrokerWeb, :controller

  def create(
        conn,
        %{
          "job_callable_key" => _,
          "job_args_serialized" => _,
          "job_kwargs_serialized" => _
        } = params
      ) do
    {:ok, event} = CutiepyBroker.Commands.enqueue_job(params)
    Phoenix.PubSub.broadcast!(CutiepyBroker.PubSub, "enqueued_job", event)
    render(conn, "response.json", event: event)
  end
end
