defmodule Mirage.Repo.Migrations.AddNoteSyndications do
  use Ecto.Migration

  def change do
    create table(:notes_syndications, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :url, :string
      add :type, :string

      add :note_id, references(:notes, on_delete: :delete_all)
    end
  end
end
