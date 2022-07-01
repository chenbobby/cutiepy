defmodule CutiepyBroker.Repo.Migrations.AlterTableJobAddJobRunTimeoutMs do
  use Ecto.Migration

  def change do
    alter table(:job) do
      add :job_run_timeout_ms, :integer
    end
  end
end
