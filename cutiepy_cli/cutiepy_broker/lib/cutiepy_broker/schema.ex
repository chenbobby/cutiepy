defmodule CutiepyBroker.Schema do
  @moduledoc """
  A customized Ecto schema that:

  - Uses UUIDs for primary and foreign keys.
  - Disables automatic timestamps. The domain logic of CutiepyBroker uses
    event sourcing. Timestamps will be managed manually.
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @type t :: %__MODULE__{}
      @primary_key {:id, Ecto.UUID, autogenerate: true}
      @foreign_key_type Ecto.UUID
      @derive {Phoenix.Param, key: :id}
      @timestamps_opts [inserted_at: false, updated_at: false]
    end
  end
end
