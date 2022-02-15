defmodule MirageWeb.TagView do
  use MirageWeb, :view

  def note_count(conn, %{notes: notes, notes_unpublished: notes_unpublished} = _tag) do
    if conn.assigns.current_user do
      Enum.count(notes ++ notes_unpublished)
    else
      Enum.count(notes)
    end
  end

  def has_unpublished_notes?(conn, tag) do
    !!conn.assigns.current_user and not Enum.empty?(tag.notes_unpublished)
  end
end
