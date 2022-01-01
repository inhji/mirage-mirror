defmodule Mirage.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :message, :string
      add :level, :string
      add :metadata, :map, default: %{}
      add :reference_id, :string

      timestamps()
    end
  end
end
