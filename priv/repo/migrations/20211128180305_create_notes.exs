defmodule Mirage.Repo.Migrations.CreateNotes do
  use Ecto.Migration

  def change do
    create table(:notes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :slug, :string
      add :content, :text
      add :content_html, :text
      add :views, :integer
      add :viewed_at, :naive_datetime
      add :published_at, :naive_datetime

      timestamps()
    end

    create unique_index(:notes, [:title])
    create unique_index(:notes, [:slug])

    create index(:notes, ["(to_tsvector('english', title))"],
             name: :notes_title_vector,
             using: "GIN"
           )

    create index(:notes, ["(to_tsvector('english', content))"],
             name: :notes_content_vector,
             using: "GIN"
           )
  end
end
