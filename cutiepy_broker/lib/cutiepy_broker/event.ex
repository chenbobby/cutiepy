defmodule CutiepyBroker.Event do
  @moduledoc false
  use CutiepyBroker.Schema

  schema "event" do
    field :timestamp, :utc_datetime_usec
    field :type, :string
    field :data, :map
  end

  def from_map(event) do
    %CutiepyBroker.Event{
      id: event.event_id,
      timestamp: event.event_timestamp,
      type: event.event_type,
      data: event
    }
  end
end
