defmodule Mirage.Repo.Migrations.RemoveBookmarks do
  use Ecto.Migration

  def change do
    drop index(:bookmarks_tags, [:bookmark_id, :tag_id])
    drop table(:bookmarks_tags)
    drop index(:bookmarks, [:user_id])
    drop index(:bookmarks, [:list_id])
    drop table(:bookmarks)
  end
end
