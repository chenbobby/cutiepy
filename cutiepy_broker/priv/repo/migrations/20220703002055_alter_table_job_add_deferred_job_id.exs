defmodule CutiepyBroker.Repo.Migrations.AlterTableJobAddDeferredJobId do
  use Ecto.Migration

  def change do
    alter table(:job) do
      add :deferred_job_id,
          references(:deferred_job, type: :uuid, on_delete: :delete_all, on_update: :update_all)
    end
  end
end
