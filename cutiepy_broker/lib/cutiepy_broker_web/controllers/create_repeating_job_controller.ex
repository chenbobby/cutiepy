defmodule CutiepyBrokerWeb.CreateRecurringJobController do
  use CutiepyBrokerWeb, :controller

  def create(
        conn,
        %{
          "start_after" => start_after,
          "interval_ms" => interval_ms,
          "function_key" => function_key,
          "args_serialized" => args_serialized,
          "kwargs_serialized" => kwargs_serialized,
          "args_repr" => args_repr,
          "kwargs_repr" => kwargs_repr,
          "job_timeout_ms" => job_timeout_ms,
          "job_run_timeout_ms" => job_run_timeout_ms
        }
      ) do
    {:ok, start_after, _} = DateTime.from_iso8601(start_after)

    case CutiepyBroker.Commands.create_recurring_job(%{
           start_after: start_after,
           interval_ms: interval_ms,
           function_key: function_key,
           args_serialized: args_serialized,
           kwargs_serialized: kwargs_serialized,
           args_repr: args_repr,
           kwargs_repr: kwargs_repr,
           job_timeout_ms: job_timeout_ms,
           job_run_timeout_ms: job_run_timeout_ms
         }) do
      {:ok, [created_recurring_job_event | _]} ->
        render(conn, "ok.json", recurring_job_id: created_recurring_job_event.recurring_job_id)
    end
  end
end
