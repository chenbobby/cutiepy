defmodule CutiepyBroker.Repo.Migrations.AlterTableJobAddRecurringJobId do
  use Ecto.Migration

  def change do
    alter table(:job) do
      add :recurring_job_id,
          references(:recurring_job, type: :uuid, on_delete: :delete_all, on_update: :update_all)
    end
  end
end
