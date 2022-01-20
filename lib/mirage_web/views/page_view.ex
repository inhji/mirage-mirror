defmodule MirageWeb.PageView do
  use MirageWeb, :view

  def is_bookmark?(%Mirage.Bookmarks.Bookmark{} = _entity), do: true
  def is_bookmark?(_), do: false

  def is_note?(%Mirage.Notes.Note{} = _entity), do: true
  def is_note?(_), do: false
end
