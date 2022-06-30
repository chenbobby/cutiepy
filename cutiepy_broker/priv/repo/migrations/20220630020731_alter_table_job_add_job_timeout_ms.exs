defmodule CutiepyBroker.Repo.Migrations.AlterTableJobAddJobTimeoutMs do
  use Ecto.Migration

  def change do
    alter table(:job) do
      add :job_timeout_ms, :integer
    end
  end
end
