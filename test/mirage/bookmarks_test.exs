defmodule Mirage.BookmarksTest do
  use Mirage.DataCase

  import Mirage.BookmarksFixtures
  import Mirage.ListsFixtures
  import Mirage.AccountsFixtures
  alias Mirage.Bookmarks.Bookmark
  alias Mirage.Bookmarks

  describe "bookmarks" do
    @invalid_attrs %{
      bookmark_of: nil,
      content: nil,
      content_html: nil,
      domain: nil,
      like_of: nil,
      published_at: nil,
      repost_of: nil,
      slug: nil,
      tags_string: nil,
      title: nil,
      url: nil,
      viewed_at: nil,
      views: nil
    }

    test "list_bookmarks/0 returns all bookmarks" do
      bookmark = bookmark_fixture()
      assert Bookmarks.list_bookmarks() == [bookmark]
    end

    test "get_bookmark!/1 returns the bookmark with given id" do
      bookmark = bookmark_fixture()
      assert Bookmarks.get_bookmark!(bookmark.id) == bookmark
    end

    test "create_bookmark/1 with valid data creates a bookmark" do
      list = list_fixture()
      user = user_fixture()

      valid_attrs = %{
        title: "some title",
        content: "some content",
        url: "some url",
        published_at: ~N[2022-01-04 21:26:00],
        bookmark_of: "some bookmark_of",
        like_of: "some like_of",
        repost_of: "some repost_of",
        user_id: user.id,
        list_id: list.id
      }

      assert {:ok, %Bookmark{} = bookmark} = Bookmarks.create_bookmark(valid_attrs)
      assert bookmark.bookmark_of == "some bookmark_of"
      assert bookmark.content == "some content"
      assert bookmark.like_of == "some like_of"
      assert bookmark.published_at == ~N[2022-01-04 21:26:00]
      assert bookmark.repost_of == "some repost_of"
      assert bookmark.title == "some title"
      assert bookmark.url == "some url"
    end

    test "create_bookmark/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bookmarks.create_bookmark(@invalid_attrs)
    end

    test "update_bookmark/2 with valid data updates the bookmark" do
      bookmark = bookmark_fixture()

      update_attrs = %{
        title: "some updated title",
        content: "some updated content",
        url: "some updated url",
        published_at: ~N[2022-01-05 21:26:00],
        bookmark_of: "some updated bookmark_of",
        like_of: "some updated like_of",
        repost_of: "some updated repost_of"
      }

      assert {:ok, %Bookmark{} = bookmark} = Bookmarks.update_bookmark(bookmark, update_attrs)
      assert bookmark.bookmark_of == "some updated bookmark_of"
      assert bookmark.content == "some updated content"
      assert bookmark.like_of == "some updated like_of"
      assert bookmark.published_at == ~N[2022-01-05 21:26:00]
      assert bookmark.repost_of == "some updated repost_of"
      assert bookmark.title == "some updated title"
      assert bookmark.url == "some updated url"
    end

    test "update_bookmark/2 with invalid data returns error changeset" do
      bookmark = bookmark_fixture()
      assert {:error, %Ecto.Changeset{}} = Bookmarks.update_bookmark(bookmark, @invalid_attrs)
      assert bookmark == Bookmarks.get_bookmark!(bookmark.id)
    end

    test "delete_bookmark/1 deletes the bookmark" do
      bookmark = bookmark_fixture()
      assert {:ok, %Bookmark{}} = Bookmarks.delete_bookmark(bookmark)
      assert_raise Ecto.NoResultsError, fn -> Bookmarks.get_bookmark!(bookmark.id) end
    end

    test "change_bookmark/1 returns a bookmark changeset" do
      bookmark = bookmark_fixture()
      assert %Ecto.Changeset{} = Bookmarks.change_bookmark(bookmark)
    end
  end
end
