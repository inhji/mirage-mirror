defmodule MirageWeb.NoteView do
  use MirageWeb, :view

  def syndication_url(%{url: nil}), do: "#"
  def syndication_url(%{url: url}), do: url

  def syndication_icon(%{type: :mastodon}), do: "openwebicons-mastodon-simple"
  def syndication_icon(%{type: _}), do: ""

  def syndication_text(%{type: :mastodon}), do: "Mastodon"
  def syndication_text(%{type: _}), do: ""

  def has_syndication?(%{url: nil}), do: false
  def has_syndication?(%{url: _}), do: true

  def note_icon(note) do
    cond do
      note.in_reply_to -> "↩️"
      note.watch_of -> "🎞️"
      note.read_of -> "📘"
      note.listen_of -> "🎧"
      note.bookmark_of -> "🔖"
      note.in_reply_to -> "↩️"
      note.like_of -> "❤️"
      note.repost_of -> "🔁"
      true -> "📝"
    end
  end

  def title_or_content(%{title: title, content_sanitized: content} = note) do
    if Mirage.Notes.Note.has_datetitle?(note) do
      String.slice(content, 0..30) <> ".."
    else
      title
    end
  end
end
