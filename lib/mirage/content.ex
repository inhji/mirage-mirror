defmodule Mirage.Content do
  def list_updates() do
    notes = Mirage.Notes.list_published_notes()
    bookmarks = Mirage.Bookmarks.list_published_bookmarks()

    Enum.sort(bookmarks ++ notes, fn item1, item2 ->
      NaiveDateTime.compare(item1.published_at, item2.published_at) == :gt
    end)
  end
end
