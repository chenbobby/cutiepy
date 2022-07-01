defmodule CutiepyBroker.Repo.Migrations.AlterTableJobsAddResultRepr do
  use Ecto.Migration

  def change do
    alter table(:job) do
      add :result_repr, :string
    end
  end
end
