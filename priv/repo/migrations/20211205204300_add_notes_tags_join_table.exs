defmodule Mirage.Repo.Migrations.AddNotesTagsJoinTable do
  use Ecto.Migration

  def change do
    create table(:notes_tags, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :note_id, references(:notes, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)
    end

    create unique_index(:notes_tags, [:note_id, :tag_id])
  end
end
