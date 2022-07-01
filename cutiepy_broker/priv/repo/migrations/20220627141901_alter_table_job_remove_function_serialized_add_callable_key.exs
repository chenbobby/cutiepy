defmodule CutiepyBroker.Repo.Migrations.AlterTableJobRemoveFunctionSerializedAddCallableKey do
  use Ecto.Migration

  def change do
    alter table(:job) do
      remove :function_serialized
      add :callable_key, :string, null: false, default: "NO_CALLABLE_KEY"
    end
  end
end
