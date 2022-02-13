defmodule Mirage.Repo.Migrations.CreateNoteImages do
  use Ecto.Migration

  def change do
    create table(:notes_images, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :filename, :string

      add :title, :string
      add :slug, :string
      
      add :content, :string
      add :content_html, :string

      add :note_id, references(:notes, on_delete: :nothing, type: :binary_id)
    end

    create index(:notes_images, [:note_id])
  end
end
