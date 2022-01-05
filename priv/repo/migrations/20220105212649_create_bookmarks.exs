defmodule Mirage.Repo.Migrations.CreateBookmarks do
  use Ecto.Migration

  def change do
    create table(:bookmarks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string
      add :slug, :string
      add :content, :string
      add :content_html, :string
      add :url, :string
      add :domain, :string
      add :tags_string, :string
      add :published_at, :naive_datetime
      add :viewed_at, :naive_datetime
      add :views, :integer
      add :like_of, :string
      add :repost_of, :string
      add :bookmark_of, :string

      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)
      add :list_id, references(:lists, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create index(:bookmarks, [:user_id])
    create index(:bookmarks, [:list_id])
  end
end
