defmodule CutiepyBroker.Repo.Migrations.DropTableDeferredJob do
  use Ecto.Migration

  def change do
    drop table(:deferred_job)
  end
end
