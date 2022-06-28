defmodule CutiepyBroker.Repo.Migrations.CreateTableJobRun do
  use Ecto.Migration

  def change do
    create table(:job_runs, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :updated_at, :utc_datetime_usec, null: false
      add :assigned_at, :utc_datetime_usec, null: false
      add :job_id, :uuid, null: false
      add :worker_id, :uuid, null: false
    end
  end
end
