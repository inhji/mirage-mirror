defmodule Mirage.Repo.Migrations.AddListIdToNotes do
  use Ecto.Migration

  def change do
    alter table(:notes) do
      add :list_id, references(:lists, on_delete: :delete_all)
    end
  end
end
