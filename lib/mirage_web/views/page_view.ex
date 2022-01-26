defmodule MirageWeb.PageView do
  use MirageWeb, :view

  def is_note?(%Mirage.Notes.Note{} = _entity), do: true
  def is_note?(_), do: false
end
