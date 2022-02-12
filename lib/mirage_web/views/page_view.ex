defmodule MirageWeb.PageView do
  use MirageWeb, :view
  import Scrivener.HTML

  def render_update(%Mirage.Notes.Note{} = update, assigns) do
    new_assigns = Map.put(assigns, :note, update)

    cond do
      like?(update) ->
        render(MirageWeb.NoteView, "like.html", new_assigns)

      page?(update) ->
        render(MirageWeb.NoteView, "page.html", new_assigns)

      true ->
        render(MirageWeb.NoteView, "note.html", new_assigns)
    end
  end
end
