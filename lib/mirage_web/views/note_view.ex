defmodule MirageWeb.NoteView do
  use MirageWeb, :view
  alias Mirage.Notes.Note

  def syndication_url(%{url: nil}), do: "#"
  def syndication_url(%{url: url}), do: url

  def syndication_icon(%{type: :mastodon}), do: "openwebicons-mastodon-simple"
  def syndication_icon(%{type: _}), do: ""

  def syndication_text(%{type: :mastodon}), do: "Mastodon"
  def syndication_text(%{type: _}), do: ""

  def bookmark?(%Note{url: url, url_type: "bookmark_of"}) when is_binary(url), do: true
  def bookmark?(_), do: false

  def like?(%Note{url: url, url_type: "like_of"}) when is_binary(url), do: true
  def like?(_), do: false

  def reply?(%Note{url: url, url_type: "reply_of"}) when is_binary(url), do: true
  def reply?(_), do: false

  @dialyzer {:no_return, {:template_not_found, 2}}
end
