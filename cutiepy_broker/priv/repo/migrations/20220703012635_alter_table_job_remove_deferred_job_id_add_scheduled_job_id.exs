defmodule CutiepyBroker.Repo.Migrations.AlterTableJobRemoveDeferredJobIdAddScheduledJobId do
  use Ecto.Migration

  def change do
    alter table(:job) do
      remove :deferred_job_id

      add :scheduled_job_id,
          references(:scheduled_job, type: :uuid, on_delete: :delete_all, on_update: :update_all)
    end
  end
end
