defmodule MirageWeb.NoteView do
  use MirageWeb, :view

  def syndication_url(%{url: nil}), do: "#"
  def syndication_url(%{url: url}), do: url

  def syndication_icon(%{type: :mastodon}), do: "openwebicons-mastodon-simple"
  def syndication_icon(%{type: _}), do: ""

  def syndication_text(%{type: :mastodon}), do: "Mastodon"
  def syndication_text(%{type: _}), do: ""

  def title_or_content(%{title: title, content_sanitized: content} = note) do
    if Mirage.Notes.Note.has_datetitle?(note) do
      String.slice(content, 0..30) <> ".."
    else
      title
    end
  end
end
