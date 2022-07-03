defmodule CutiepyBroker.Repo.Migrations.AlterTableRecurringJobAddLastEnqueuedAt do
  use Ecto.Migration

  def change do
    alter table(:recurring_job) do
      add :last_enqueued_at, :utc_datetime_usec
    end
  end
end
