defmodule MirageWeb.Admin.BookmarkControllerTest do
  use MirageWeb.ConnCase

  import Mirage.BookmarksFixtures
  import Mirage.ListsFixtures

  @update_attrs %{
    bookmark_of: "some updated bookmark_of",
    content: "some updated content",
    domain: "some updated domain",
    like_of: "some updated like_of",
    repost_of: "some updated repost_of",
    title: "some updated title",
    url: "some updated url"
  }
  @invalid_attrs %{
    bookmark_of: nil,
    content: nil,
    domain: nil,
    like_of: nil,
    repost_of: nil,
    title: nil,
    url: nil
  }

  setup :register_and_log_in_user

  describe "index" do
    test "lists all bookmarks", %{conn: conn} do
      conn = get(conn, Routes.admin_bookmark_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Bookmarks"
    end
  end

  describe "new bookmark" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.admin_bookmark_path(conn, :new))
      assert html_response(conn, 200) =~ "New Bookmark"
    end
  end

  describe "create bookmark" do
    setup [:create_list]

    test "redirects to show when data is valid", %{conn: conn, user: user, list: list} do
      create_attrs = %{
        bookmark_of: "some bookmark_of",
        content: "some content",
        content_html: "some content_html",
        domain: "some domain",
        like_of: "some like_of",
        published_at: ~N[2022-01-04 21:26:00],
        repost_of: "some repost_of",
        slug: "some slug",
        title: "some title",
        url: "some url",
        user_id: user.id,
        list_id: list.id,
        tags_string: "some,tags"
      }

      conn = post(conn, Routes.admin_bookmark_path(conn, :create), bookmark: create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.admin_bookmark_path(conn, :show, id)

      conn = get(conn, Routes.admin_bookmark_path(conn, :show, id))
      assert html_response(conn, 200)
      assert html_response(conn, 200) =~ "some"
      assert html_response(conn, 200) =~ "tags"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.admin_bookmark_path(conn, :create), bookmark: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Bookmark"
    end
  end

  describe "edit bookmark" do
    setup [:create_bookmark]

    test "renders form for editing chosen bookmark", %{conn: conn, bookmark: bookmark} do
      conn = get(conn, Routes.admin_bookmark_path(conn, :edit, bookmark))
      assert html_response(conn, 200) =~ "Edit Bookmark"
    end
  end

  describe "update bookmark" do
    setup [:create_bookmark]

    test "redirects when data is valid", %{conn: conn, bookmark: bookmark} do
      conn =
        put(conn, Routes.admin_bookmark_path(conn, :update, bookmark), bookmark: @update_attrs)

      assert redirected_to(conn) == Routes.admin_bookmark_path(conn, :show, bookmark)

      conn = get(conn, Routes.admin_bookmark_path(conn, :show, bookmark))
      assert html_response(conn, 200) =~ "some updated bookmark_of"
    end

    test "renders errors when data is invalid", %{conn: conn, bookmark: bookmark} do
      conn =
        put(conn, Routes.admin_bookmark_path(conn, :update, bookmark), bookmark: @invalid_attrs)

      assert html_response(conn, 200) =~ "Edit Bookmark"
    end
  end

  describe "publish bookmark" do
    setup [:create_bookmark]

    test "publishes a bookmark", %{conn: conn, bookmark: bookmark} do
      conn = get(conn, Routes.admin_bookmark_path(conn, :publish, bookmark), id: bookmark.id)
      assert redirected_to(conn) == Routes.admin_bookmark_path(conn, :show, bookmark)

      conn = get(conn, Routes.admin_bookmark_path(conn, :show, bookmark))
      assert html_response(conn, 200) =~ "Unpublish"
    end

    test "unpublishes a bookmark", %{conn: conn, bookmark: bookmark} do
      conn = get(conn, Routes.admin_bookmark_path(conn, :unpublish, bookmark), id: bookmark.id)
      assert redirected_to(conn) == Routes.admin_bookmark_path(conn, :show, bookmark)

      conn = get(conn, Routes.admin_bookmark_path(conn, :show, bookmark))
      assert html_response(conn, 200) =~ "Publish"
    end
  end

  describe "delete bookmark" do
    setup [:create_bookmark]

    test "deletes chosen bookmark", %{conn: conn, bookmark: bookmark} do
      conn = delete(conn, Routes.admin_bookmark_path(conn, :delete, bookmark))
      assert redirected_to(conn) == Routes.admin_bookmark_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.admin_bookmark_path(conn, :show, bookmark))
      end
    end
  end
end
