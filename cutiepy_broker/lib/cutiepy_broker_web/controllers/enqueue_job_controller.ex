defmodule CutiepyBrokerWeb.EnqueueJobController do
  use CutiepyBrokerWeb, :controller

  def create(
        conn,
        %{
          "job_callable_key" => job_callable_key,
          "job_args_serialized" => job_args_serialized,
          "job_kwargs_serialized" => job_kwargs_serialized,
          "job_args_repr" => job_args_repr,
          "job_kwargs_repr" => job_kwargs_repr
        }
      ) do
    case CutiepyBroker.Commands.enqueue_job(%{
           job_callable_key: job_callable_key,
           job_args_serialized: job_args_serialized,
           job_kwargs_serialized: job_kwargs_serialized,
           job_args_repr: job_args_repr,
           job_kwargs_repr: job_kwargs_repr
         }) do
      {:ok, event} ->
        render(conn, "response.json", event: event)
    end
  end
end
