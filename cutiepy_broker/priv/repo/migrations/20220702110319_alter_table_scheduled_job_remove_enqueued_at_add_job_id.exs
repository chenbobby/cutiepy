defmodule CutiepyBroker.Repo.Migrations.AlterTableScheduledJobRemoveEnqueuedAtAddJobId do
  use Ecto.Migration

  def change do
    alter table(:scheduled_job) do
      remove :enqueued_at
      add :job_id, references(:job, type: :uuid, on_delete: :delete_all, on_update: :update_all)
    end
  end
end
