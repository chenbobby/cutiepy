defmodule CutiepyBroker.Event do
  @moduledoc false
  use CutiepyBroker.Schema

  schema "events" do
    field :data, :map
  end

  def flatten(event) do
    Map.put(event.data, :id, event.id)
  end
end
