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
    {:ok, job_id} = CutiepyBroker.Commands.enqueue_job(job_params)
    render(conn, "enqueued.json", job_id: job_id)
  end
end
