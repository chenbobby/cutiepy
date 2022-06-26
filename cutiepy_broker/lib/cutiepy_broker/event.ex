defmodule CutiepyBroker.Event do
  @moduledoc false
  use CutiepyBroker.Schema

  schema "events" do
    field(:data, :map)
  end
end
