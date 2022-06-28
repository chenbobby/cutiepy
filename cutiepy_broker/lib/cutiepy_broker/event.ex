defmodule CutiepyBroker.Event do
  @moduledoc false
  use CutiepyBroker.Schema

  schema "events" do
    field :data, :map
  end

  def from_map(event) do
    %CutiepyBroker.Event{
      id: event["id"],
      data: Map.delete(event, "id")
    }
  end
end
