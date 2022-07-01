defmodule CutiepyBroker.Repo.Migrations.AlterTableJobRunAddResultSerializedAddResultRepr do
  use Ecto.Migration

  def change do
    alter table(:job_run) do
      add :result_serialized, :string
      add :result_repr, :string
    end
  end
end
