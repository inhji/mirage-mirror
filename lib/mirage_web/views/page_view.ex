defmodule MirageWeb.PageView do
  use MirageWeb, :view
  import Scrivener.HTML

  def render_update(%Mirage.Notes.Note{} = update, assigns, options \\ %{}) do
    is_preview = Map.get_lazy(options, :preview, fn -> false end)

    new_assigns =
      assigns
      |> Map.put(:note, update)
      |> Map.put(:preview, is_preview)

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
