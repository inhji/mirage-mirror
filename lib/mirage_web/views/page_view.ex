defmodule MirageWeb.PageView do
  use MirageWeb, :view
  import Scrivener.HTML

  def is_note?(%Mirage.Notes.Note{} = _entity), do: true
  def is_note?(_), do: false
end
