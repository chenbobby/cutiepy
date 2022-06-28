defmodule CutiepyBroker.Event do
  @moduledoc false
  use CutiepyBroker.Schema

  schema "events" do
    field :data, :map
  end

  def string_map(event) do
    for {k, v} <- event.data,
        into: %{"id" => event.id},
        do: {to_string(k), v}
  end
end
