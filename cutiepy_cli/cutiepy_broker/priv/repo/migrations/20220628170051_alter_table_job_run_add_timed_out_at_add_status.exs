defmodule CutiepyBroker.Repo.Migrations.AlterTableJobRunsAddTimedOutAtAddStatus do
  use Ecto.Migration

  def change do
    alter table(:job_run) do
      add :timed_out_at, :utc_datetime_usec
      add :status, :string, null: false, default: "NO_STATUS"
    end
  end
end
