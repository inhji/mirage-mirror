defmodule Mirage.BookmarkTags do
  @moduledoc """
  The BookmarkTags context
  """

  import Ecto.Query, warn: false
  alias Mirage.Repo
  alias Mirage.Bookmarks.BookmarkTag

  def get_bookmark_tag!(attrs \\ %{}) do
    Repo.get_by!(BookmarkTag, attrs)
  end

  def create_bookmark_tag(attrs \\ %{}) do
    %BookmarkTag{}
    |> BookmarkTag.changeset(attrs)
    |> Repo.insert()
  end

  def delete_bookmark_tag(%BookmarkTag{} = bookmark_tag) do
    Repo.delete(bookmark_tag)
  end
end
