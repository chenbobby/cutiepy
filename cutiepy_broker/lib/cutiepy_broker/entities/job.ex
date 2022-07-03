defmodule CutiepyBroker.Job do
  @moduledoc false
  use CutiepyBroker.Schema

  schema "job" do
    field :updated_at, :utc_datetime_usec
    field :enqueued_at, :utc_datetime_usec
    field :completed_at, :utc_datetime_usec
    field :failed_at, :utc_datetime_usec
    field :timed_out_at, :utc_datetime_usec

    field :status, :string

    field :function_key, :string
    field :args_serialized, :string
    field :kwargs_serialized, :string
    field :args_repr, {:array, :string}
    field :kwargs_repr, {:map, :string}
    field :job_timeout_ms, :integer
    field :job_run_timeout_ms, :integer

    field :deferred_job_id, Ecto.UUID
  end
end
