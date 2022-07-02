defmodule CutiepyBroker.Repo.Migrations.DropTableScheduledJob do
  use Ecto.Migration

  def change do
    drop table(:scheduled_job)
  end
end
