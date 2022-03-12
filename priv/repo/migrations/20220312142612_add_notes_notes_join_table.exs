defmodule Mirage.Repo.Migrations.AddNotesNotesJoinTable do
  use Ecto.Migration

  def change do
    create table(:notes_notes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :source_id, references(:notes, on_delete: :delete_all)
      add :target_id, references(:notes, on_delete: :delete_all)
    end

    create unique_index(:notes_notes, [:source_id, :target_id])
  end
end
