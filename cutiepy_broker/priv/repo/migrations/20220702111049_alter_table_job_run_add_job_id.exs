defmodule CutiepyBroker.Repo.Migrations.AlterTableJobRunAddJobId do
  use Ecto.Migration

  def change do
    alter table(:job_run) do
      add :job_id,
          references(:job, type: :uuid, on_delete: :delete_all, on_update: :update_all),
          null: false
    end
  end
end
