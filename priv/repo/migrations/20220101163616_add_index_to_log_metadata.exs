defmodule Mirage.Repo.Migrations.AddIndexToLogMetadata do
  use Ecto.Migration

  def up do
    execute("CREATE INDEX logs_metadata ON logs USING GIN(metadata)")
  end

  def down do
    execute("DROP INDEX logs_metadata")
  end
end
