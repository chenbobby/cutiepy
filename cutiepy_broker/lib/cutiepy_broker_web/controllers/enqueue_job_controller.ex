defmodule CutiepyBrokerWeb.EnqueueJobController do
  use CutiepyBrokerWeb, :controller

  def create(
        conn,
        %{
          "job_callable_key" => _,
          "job_args_serialized" => _,
          "job_kwargs_serialized" => _,
          "job_args_repr" => _,
          "job_kwargs_repr" => _
        } = params
      ) do
    case CutiepyBroker.Commands.enqueue_job(params) do
      {:ok, event} ->
        render(conn, "response.json", event: event)
    end
  end
end
