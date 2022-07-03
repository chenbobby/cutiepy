defmodule CutiepyBroker.Repo.Migrations.AlterTableDeferredJobRemoveJobId do
  use Ecto.Migration

  def change do
    alter table(:deferred_job) do
      remove :job_id
    end
  end
end
