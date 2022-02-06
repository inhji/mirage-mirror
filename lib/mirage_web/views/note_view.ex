defmodule MirageWeb.NoteView do
  use MirageWeb, :view

  def syndication_url(%{url: nil} = syndication), do: "#"
  def syndication_url(%{url: url} = syndication), do: url
end
