defmodule Mirage.BookmarksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mirage.Bookmarks` context.
  """

  import Mirage.ListsFixtures
  import Mirage.AccountsFixtures

  @doc """
  Generate a bookmark.
  """
  def bookmark_fixture(attrs \\ %{}) do
    title = "list-#{Mirage.Helper.random_string()}"
    list = list_fixture(title: title)
    user = user_fixture()

    {:ok, bookmark} =
      attrs
      |> Enum.into(%{
        bookmark_of: "some bookmark_of",
        content: "some content",
        domain: "some domain",
        like_of: "some like_of",
        repost_of: "some repost_of",
        title: "some title",
        url: "some url",
        list_id: list.id,
        user_id: user.id
      })
      |> Mirage.Bookmarks.create_bookmark()

    bookmark |> Mirage.Bookmarks.preload_bookmark()
  end
end
