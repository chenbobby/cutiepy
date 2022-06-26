defmodule CutiepyBroker.Job do
  @moduledoc false
  use CutiepyBroker.Schema

  schema "jobs" do
    field(:updated_at, :utc_datetime_usec)
    field(:enqueued_at, :utc_datetime_usec)
    field(:function_serialized, :string)
    field(:args_serialized, :string)
    field(:kwargs_serialized, :string)
  end
end
