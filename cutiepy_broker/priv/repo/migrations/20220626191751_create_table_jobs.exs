defmodule CutiepyBroker.Repo.Migrations.CreateTableJobs do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:updated_at, :utc_datetime_usec)
      add(:enqueued_at, :utc_datetime_usec)
      add(:function_serialized, :string)
      add(:args_serialized, :string)
      add(:kwargs_serialized, :string)
    end
  end
end
