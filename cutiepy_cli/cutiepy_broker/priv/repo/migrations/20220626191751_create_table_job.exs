defmodule CutiepyBroker.Repo.Migrations.CreateTableJobs do
  use Ecto.Migration

  def change do
    create table(:job, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :updated_at, :utc_datetime_usec, null: false
      add :enqueued_at, :utc_datetime_usec, null: false
      add :function_serialized, :string, null: false
      add :args_serialized, :string, null: false
      add :kwargs_serialized, :string, null: false
    end
  end
end
