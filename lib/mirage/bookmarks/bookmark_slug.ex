defmodule Mirage.Bookmarks.BookmarkSlug do
  @moduledoc """
  Bookmark slug module
  """
  use EctoAutoslugField.Slug, from: :title, to: :slug
end
