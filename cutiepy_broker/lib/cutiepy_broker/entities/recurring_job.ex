defmodule CutiepyBroker.RecurringJob do
  use CutiepyBroker.Schema

  schema "recurring_job" do
    field :updated_at, :utc_datetime_usec
    field :created_at, :utc_datetime_usec
    field :last_enqueued_at, :utc_datetime_usec

    field :start_after, :utc_datetime_usec
    field :interval_ms, :integer
    field :enqueue_next_job_after, :utc_datetime_usec

    field :function_key, :string
    field :args_serialized, :string
    field :kwargs_serialized, :string
    field :args_repr, {:array, :string}
    field :kwargs_repr, {:map, :string}
    field :job_timeout_ms, :integer
    field :job_run_timeout_ms, :integer
  end
end
