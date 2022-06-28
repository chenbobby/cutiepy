defmodule CutiepyBrokerWeb.EnqueueJobController do
  use CutiepyBrokerWeb, :controller

  def create(
        conn,
        %{
          "job" =>
            %{
              "callable_key" => _,
              "args_serialized" => _,
              "kwargs_serialized" => _
            } = job_params
        }
      ) do
    {:ok, event} = CutiepyBroker.Commands.enqueue_job(job_params)
    Phoenix.PubSub.broadcast!(CutiepyBroker.PubSub, "enqueued_job", event)
    render(conn, "enqueued.json", job_id: event.job_id)
  end
end
