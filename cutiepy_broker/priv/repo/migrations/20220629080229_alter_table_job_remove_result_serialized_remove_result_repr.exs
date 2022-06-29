defmodule CutiepyBroker.Repo.Migrations.AlterTableJobRemoveResultSerializedRemoveResultRepr do
  use Ecto.Migration

  def change do
    alter table(:job) do
      remove :result_serialized
      remove :result_repr
    end
  end
end
