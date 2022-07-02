defmodule CutiepyBroker.Repo.Migrations.AlterTableJobRunRemoveJobId do
  use Ecto.Migration

  def change do
    alter table(:job_run) do
      remove :job_id
    end
  end
end
