defmodule Mirage.Repo.Migrations.CreateLists do
  use Ecto.Migration

  def change do
    create table(:lists, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :slug, :string
      add :content, :string
      add :content_html, :string
      add :display_type, :string
      add :published_at, :naive_datetime
      add :viewed_at, :naive_datetime
      add :views, :integer

      timestamps()
    end

    create unique_index(:lists, [:title])
    create unique_index(:lists, [:slug])

    create index(:lists, ["(to_tsvector('english', title))"],
             name: :lists_title_vector,
             using: "GIN"
           )

    create index(:lists, ["(to_tsvector('english', content))"],
             name: :lists_content_vector,
             using: "GIN"
           )
  end
end
