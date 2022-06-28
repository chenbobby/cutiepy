defmodule CutiepyBroker.Job do
  @moduledoc false
  use CutiepyBroker.Schema

  schema "jobs" do
    field :updated_at, :utc_datetime_usec
    field :enqueued_at, :utc_datetime_usec
    field :status, :string
    field :callable_key, :string
    field :args_serialized, :string
    field :kwargs_serialized, :string
    field :result_serialized, :string
    field :args_repr, {:array, :string}
    field :kwargs_repr, {:map, :string}
    field :result_repr, :string
  end
end
