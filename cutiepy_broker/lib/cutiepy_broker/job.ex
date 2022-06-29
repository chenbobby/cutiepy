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
    field :callable_key, :string
    field :args_serialized, :string
    field :args_repr, {:array, :string}
    field :kwargs_serialized, :string
    field :kwargs_repr, {:map, :string}
  end
end
