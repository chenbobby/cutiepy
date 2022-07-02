defmodule CutiepyBroker.ScheduledJob do
  use CutiepyBroker.Schema

  schema "scheduled_job" do
    field :updated_at, :utc_datetime_usec
    field :scheduled_at, :utc_datetime_usec
    field :enqueue_after, :utc_datetime_usec
    field :enqueued_at, :utc_datetime_usec
    field :function_key, :string
    field :args_serialized, :string
    field :kwargs_serialized, :string
    field :args_repr, {:array, :string}
    field :kwargs_repr, {:map, :string}
    field :job_timeout_ms, :integer
    field :job_run_timeout_ms, :integer
  end
end
