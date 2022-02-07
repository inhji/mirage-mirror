defmodule MirageWeb.ViewHelpers do
  def datetime_for_display(datetime) do
    Timex.format!(datetime, "{D}. {Mshort} {YYYY}, {h24}:{m}")
  end

  def datetime_from_now(nil), do: nil
  def datetime_from_now(datetime), do: Timex.from_now(datetime)

  def note_title(note) do
    if page?(note) do
      length = byte_size(note.title)
      String.slice(note.title, 1..length)
    else
      note.title
    end
  end

  def page?(note) do
    String.starts_with?(note.title, "@")
  end
end
