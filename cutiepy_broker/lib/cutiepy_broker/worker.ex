defmodule CutiepyBroker.Worker do
  use CutiepyBroker.Schema

  schema "worker" do
    field :updated_at, :utc_datetime_usec
  end
end
