defmodule CutiepyBroker.Repo.Migrations.CreateTableJobRun do
  use Ecto.Migration

  def change do
    create table(:job_run, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :updated_at, :utc_datetime_usec, null: false
      add :assigned_at, :utc_datetime_usec, null: false
      add :job_id, references(:job, type: :uuid, on_delete: :delete_all, on_update: :update_all)
      add :worker_id, :uuid, null: false
    end
  end
end
