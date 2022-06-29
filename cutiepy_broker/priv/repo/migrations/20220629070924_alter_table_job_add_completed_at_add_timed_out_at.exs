defmodule CutiepyBroker.Repo.Migrations.AlterTableJobAddCompletedAtAddTimedOutAt do
  use Ecto.Migration

  def change do
    alter table(:job) do
      add :completed_at, :utc_datetime_usec
      add :timed_out_at, :utc_datetime_usec
    end
  end
end
