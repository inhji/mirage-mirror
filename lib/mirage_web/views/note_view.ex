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
      note.in_reply_to -> "âŠī¸"
      note.watch_of -> "đī¸"
      note.read_of -> "đ"
      note.listen_of -> "đ§"
      note.bookmark_of -> "đ"
      note.in_reply_to -> "âŠī¸"
      note.like_of -> "â¤ī¸"
      note.repost_of -> "đ"
      true -> "đ"
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
