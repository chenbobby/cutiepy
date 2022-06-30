defmodule CutiepyBroker.Repo.Migrations.AlterTableJobRunAddCanceledAt do
  use Ecto.Migration

  def change do
    alter table(:job_run) do
      add :canceled_at, :utc_datetime_usec
    end
  end
end
