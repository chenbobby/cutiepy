defmodule CutiepyBroker.Repo.Migrations.CreateTableScheduledJob do
  use Ecto.Migration

  def change do
    create table(:scheduled_job, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :updated_at, :utc_datetime_usec, null: false
      add :created_at, :utc_datetime_usec, null: false
      add :enqueued_at, :utc_datetime_usec
      add :enqueue_after, :utc_datetime_usec, null: false
      add :function_key, :string, null: false
      add :args_serialized, :string, null: false
      add :kwargs_serialized, :string, null: false
      add :args_repr, {:array, :string}, null: false
      add :kwargs_repr, {:map, :string}, null: false
      add :job_timeout_ms, :integer
      add :job_run_timeout_ms, :integer
    end
  end
end
