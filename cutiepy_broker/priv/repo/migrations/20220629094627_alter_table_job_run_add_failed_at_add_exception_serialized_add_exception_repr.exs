defmodule CutiepyBroker.Repo.Migrations.AlterTableJobRunAddFailedAtAddErrorSerializedAddErrorRepr do
  use Ecto.Migration

  def change do
    alter table(:job_run) do
      add :failed_at, :utc_datetime_usec
      add :exception_serialized, :string
      add :exception_repr, :string
    end
  end
end
