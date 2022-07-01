defmodule CutiepyBroker.Repo.Migrations.AlterTableJobAddFailedAt do
  use Ecto.Migration

  def change do
    alter table(:job) do
      add :failed_at, :utc_datetime_usec
    end
  end
end
