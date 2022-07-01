defmodule CutiepyBroker.Repo.Migrations.AlterTableJobRemoveCallableKeyAddFunctionKey do
  use Ecto.Migration

  def change do
    alter table(:job) do
      remove :callable_key
      add :function_key, :string, null: false, default: "NO_FUNCTION_KEY"
    end
  end
end
