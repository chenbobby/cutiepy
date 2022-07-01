defmodule CutiepyBroker.Repo.Migrations.AlterTableJobRunsAddCompletedAt do
  use Ecto.Migration

  def change do
    alter table(:job_run) do
      add :completed_at, :utc_datetime_usec
    end
  end
end
