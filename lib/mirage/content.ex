defmodule Mirage.Content do
  def list_updates(pagination_params \\ %{}) do
    Mirage.Notes.list_published_notes(pagination_params)
  end

  def list_bookmarks() do
    Mirage.Notes.list_bookmarks()
  end
end
