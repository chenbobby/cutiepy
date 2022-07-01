defmodule CutiepyBroker.Repo.Migrations.CreateTableEvent2 do
  use Ecto.Migration

  def change do
    create table(:event, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :timestamp, :utc_datetime_usec, null: false
      add :type, :string, null: false
      add :data, :map, null: false
    end
  end
end
