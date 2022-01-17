defmodule Mirage.Repo.Migrations.AddBookmarksTagsJoinTable do
  use Ecto.Migration

  def change do
    create table(:bookmarks_tags, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :bookmark_id, references(:bookmarks, on_delete: :delete_all)
      add :tag_id, references(:tags, on_delete: :delete_all)
    end

    create unique_index(:bookmarks_tags, [:bookmark_id, :tag_id])
  end
end
