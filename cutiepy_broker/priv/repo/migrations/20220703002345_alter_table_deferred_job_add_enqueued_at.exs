defmodule CutiepyBroker.Repo.Migrations.AlterTableDeferredJobAddEnqueuedAt do
  use Ecto.Migration

  def change do
    alter table(:deferred_job) do
      add :enqueued_at, :utc_datetime_usec
    end
  end
end
