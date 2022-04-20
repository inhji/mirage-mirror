defmodule Mirage.Repo.Migrations.AddDefaultList do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :default_list_id, references(:lists, on_delete: :nothing, type: :binary_id)
    end
  end
end
