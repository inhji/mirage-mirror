defmodule Mirage.Bookmarks.BookmarkTag do
  @moduledoc """
  The BookmarkTag module
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "bookmarks_tags" do
    belongs_to :bookmark, Mirage.Bookmarks.Bookmark
    belongs_to :tag, Mirage.Tags.Tag
  end

  @doc false
  def changeset(bookmark_tag, attrs) do
    bookmark_tag
    |> cast(attrs, [:bookmark_id, :tag_id])
    |> validate_required([:bookmark_id, :tag_id])
  end
end
