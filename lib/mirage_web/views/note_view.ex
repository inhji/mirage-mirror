defmodule MirageWeb.NoteView do
  use MirageWeb, :view

  def syndication_url(%{url: nil}), do: "#"
  def syndication_url(%{url: url}), do: url

  def syndication_icon(%{type: :mastodon}), do: "openwebicons-mastodon-simple"
  def syndication_icon(%{type: _}), do: ""

  def syndication_text(%{type: :mastodon}), do: "Mastodon"
  def syndication_text(%{type: _}), do: ""
end
