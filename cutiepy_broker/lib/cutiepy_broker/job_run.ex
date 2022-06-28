defmodule CutiepyBroker.JobRun do
  @moduledoc false
  use CutiepyBroker.Schema

  schema "job_runs" do
    field :updated_at, :utc_datetime_usec
    field :assigned_at, :utc_datetime_usec
    field :completed_at, :utc_datetime_usec
    field :job_id, :string
    field :worker_id, :string
  end
end
