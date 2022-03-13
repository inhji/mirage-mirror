defmodule Mirage.Notes.NoteLinkUpdater do
  require Logger

  def add_note_links(origin_note, slugs) do
    Enum.each(slugs, fn slug ->
      linked_note = Mirage.Notes.get_note!(slug)
      attrs = get_attrs(origin_note.id, linked_note.id)

      case Mirage.NoteNotes.create_note_note(attrs) do
        {:ok, _note_note} ->
          Logger.info("Reference to '#{slug}' created")

        error ->
          Logger.warn(error)
      end
    end)
  end

  def remove_note_links(origin_note, slugs) do
    Enum.each(slugs, fn slug ->
      linked_note = Mirage.Notes.get_note!(slug)
      attrs = get_attrs(origin_note.id, linked_note.id)
      note_note = Mirage.NoteNotes.get_note_note(attrs)

      case Mirage.NoteNotes.delete_note_note(note_note) do
        {:ok, _note_note} ->
          Logger.info("Reference to '#{slug}' deleted")

        error ->
          Logger.warn(error)
      end
    end)
  end

  defp get_attrs(origin_id, linked_id) do
    %{
      source_id: origin_id,
      target_id: linked_id
    }
  end
end
