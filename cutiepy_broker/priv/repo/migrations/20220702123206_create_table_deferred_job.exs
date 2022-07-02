defmodule CutiepyBroker.Repo.Migrations.CreateTableDeferredJob do
  use Ecto.Migration

  def change do
    create table(:deferred_job, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :updated_at, :utc_datetime_usec, null: false
      add :created_at, :utc_datetime_usec, null: false
      add :enqueue_after, :utc_datetime_usec, null: false
      add :function_key, :string, null: false
      add :args_serialized, :string, null: false
      add :kwargs_serialized, :string, null: false
      add :args_repr, {:array, :string}, null: false
      add :kwargs_repr, {:map, :string}, null: false
      add :job_timeout_ms, :integer
      add :job_run_timeout_ms, :integer
      add :job_id, references(:job, type: :uuid, on_delete: :delete_all, on_update: :update_all)
    end
  end
end
