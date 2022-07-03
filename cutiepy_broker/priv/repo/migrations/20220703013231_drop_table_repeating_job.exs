defmodule CutiepyBroker.Repo.Migrations.DropTableRepeatingJob do
  use Ecto.Migration

  def change do
    drop table(:repeating_job)
  end
end
