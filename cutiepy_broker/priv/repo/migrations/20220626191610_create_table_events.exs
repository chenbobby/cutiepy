defmodule CutiepyBroker.Repo.Migrations.CreateTableEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:data, :map)
    end
  end
end
