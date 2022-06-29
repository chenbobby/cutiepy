defmodule CutiepyBroker.Repo.Migrations.AlterTableJobsAddResultSerialized do
  use Ecto.Migration

  def change do
    alter table(:job) do
      add :result_serialized, :string
    end
  end
end
