defmodule CutiepyBroker.Repo.Migrations.AlterTableJobsAddStatus do
  use Ecto.Migration

  def change do
    alter table(:jobs) do
      add :status, :string, null: false, default: "NO_STATUS"
    end
  end
end
