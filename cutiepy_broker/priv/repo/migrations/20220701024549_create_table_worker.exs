defmodule CutiepyBroker.Repo.Migrations.CreateTableWorker do
  use Ecto.Migration

  def change do
    create table(:worker, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :updated_at, :utc_datetime_usec, null: false
    end
  end
end
