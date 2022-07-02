defmodule CutiepyBrokerWeb.CreateDeferredJobController do
  use CutiepyBrokerWeb, :controller

  def create(
        conn,
        %{
          "enqueue_after" => enqueue_after,
          "function_key" => function_key,
          "args_serialized" => args_serialized,
          "kwargs_serialized" => kwargs_serialized,
          "args_repr" => args_repr,
          "kwargs_repr" => kwargs_repr,
          "job_timeout_ms" => job_timeout_ms,
          "job_run_timeout_ms" => job_run_timeout_ms
        }
      ) do
    {:ok, enqueue_after, _} = DateTime.from_iso8601(enqueue_after)

    case CutiepyBroker.Commands.create_deferred_job(%{
           enqueue_after: enqueue_after,
           function_key: function_key,
           args_serialized: args_serialized,
           kwargs_serialized: kwargs_serialized,
           args_repr: args_repr,
           kwargs_repr: kwargs_repr,
           job_timeout_ms: job_timeout_ms,
           job_run_timeout_ms: job_run_timeout_ms
         }) do
      {:ok, [created_deferred_job_event | _]} ->
        render(conn, "ok.json", deferred_job_id: created_deferred_job_event.deferred_job_id)
    end
  end
end
