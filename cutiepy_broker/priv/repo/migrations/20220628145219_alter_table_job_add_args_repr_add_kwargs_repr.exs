defmodule CutiepyBroker.Repo.Migrations.AlterTableJobsAddArgsReprAddKwargsRepr do
  use Ecto.Migration

  def change do
    alter table(:job) do
      add :args_repr, {:array, :string}, null: false, default: []
      add :kwargs_repr, {:map, :string}, null: false, default: %{}
    end
  end
end
