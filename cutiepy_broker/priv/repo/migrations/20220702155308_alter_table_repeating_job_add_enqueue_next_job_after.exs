defmodule CutiepyBroker.Repo.Migrations.AlterTableRepeatingJobAddEnqueueNextJobAfter do
  use Ecto.Migration

  def change do
    alter table(:repeating_job) do
      add :enqueue_next_job_after, :utc_datetime_usec
    end
  end
end
