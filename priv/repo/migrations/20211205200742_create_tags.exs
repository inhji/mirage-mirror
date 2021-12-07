defmodule Mirage.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :slug, :string
      add :content, :string
      add :content_html, :string
      add :icon, :string
      add :regex, :string

      timestamps()
    end

    create unique_index(:tags, [:title])
    create unique_index(:tags, [:slug])
    create index(:tags, ["(to_tsvector('english', title))"], 
      name: :tags_title_vector, using: "GIN")
    create index(:tags, ["(to_tsvector('english', content))"], 
      name: :tags_content_vector, using: "GIN")
  end
end
