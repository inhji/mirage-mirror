defmodule Mirage.Repo.Migrations.AddContentSanitizedToBookmark do
  use Ecto.Migration

  def up do
    alter table(:bookmarks) do
      add :content_sanitized, :text
    end

    flush()

    repo().all(Mirage.Bookmarks.Bookmark)
    |> Enum.each(fn bookmark -> 
      text = HtmlSanitizeEx.strip_tags(bookmark.content_html) 
      changeset = Ecto.Changeset.cast(bookmark, %{content_sanitized: text}, [:content_sanitized])
      repo().update(changeset)
    end)
  end

  def down do
    alter table(:bookmarks) do
      remove :content_sanitized
    end
  end
end
