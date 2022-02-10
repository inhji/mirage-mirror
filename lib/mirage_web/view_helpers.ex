defmodule MirageWeb.ViewHelpers do
  alias Mirage.Notes.Note

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

  def page?(%Mirage.Notes.Note{title: title}) do
    String.starts_with?(title, "@")
  end

  def note?(%Mirage.Notes.Note{}), do: true
  def note?(_), do: false

  def bookmark?(%Note{url: url, url_type: "bookmark_of"}) when is_binary(url), do: true
  def bookmark?(_), do: false

  def like?(%Note{url: url, url_type: "like_of"}) when is_binary(url), do: true
  def like?(_), do: false

  def reply?(%Note{url: url, url_type: "reply_of"}) when is_binary(url), do: true
  def reply?(_), do: false
end
