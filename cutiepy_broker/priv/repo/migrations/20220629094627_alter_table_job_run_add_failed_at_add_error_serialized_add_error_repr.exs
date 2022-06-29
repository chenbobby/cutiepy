defmodule CutiepyBroker.Repo.Migrations.AlterTableJobRunAddFailedAtAddErrorSerializedAddErrorRepr do
  use Ecto.Migration

  def change do
    alter table(:job_run) do
      add :failed_at, :utc_datetime_usec
      add :error_serialized, :string
      add :error_repr, :string
    end
  end
end
