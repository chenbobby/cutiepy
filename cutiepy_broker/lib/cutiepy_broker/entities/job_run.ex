defmodule CutiepyBroker.JobRun do
  @moduledoc false
  use CutiepyBroker.Schema

  schema "job_run" do
    field :updated_at, :utc_datetime_usec
    field :assigned_at, :utc_datetime_usec
    field :canceled_at, :utc_datetime_usec
    field :completed_at, :utc_datetime_usec
    field :failed_at, :utc_datetime_usec
    field :timed_out_at, :utc_datetime_usec

    field :status, :string
    field :result_serialized, :string
    field :result_repr, :string
    field :exception_serialized, :string
    field :exception_repr, :string

    field :job_id, Ecto.UUID
    field :worker_id, Ecto.UUID
  end
end
