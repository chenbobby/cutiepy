defmodule CutiepyBroker.Repo.Migrations.DropTableEvent do
  use Ecto.Migration

  def change do
    drop table(:event)
  end
end
