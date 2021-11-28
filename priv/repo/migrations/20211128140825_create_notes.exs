defmodule Mirage.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :slug, :string
      add :content, :string
      add :content_html, :string
      add :views, :integer
      add :viewed_at, :naive_datetime
      add :published_at, :naive_datetime

      timestamps()
    end
  end
end
