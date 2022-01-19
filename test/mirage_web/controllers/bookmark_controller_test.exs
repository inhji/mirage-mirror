defmodule MirageWeb.BookmarkControllerTest do
  use MirageWeb.ConnCase
  import Mirage.BookmarksFixtures

  describe "BookmarkController" do
    setup [:create_bookmark]

    test "GET /bookmarks", %{conn: conn} do
      conn = get(conn, Routes.bookmark_path(conn, :index))
      assert html_response(conn, 200) =~ "Bookmarks"
    end

    test "GET /bookmarks/:id", %{conn: conn, bookmark: bookmark} do
      conn = get(conn, Routes.bookmark_path(conn, :show, bookmark.slug))
      assert html_response(conn, 200) =~ bookmark.title
    end

    test "GET /bookmarks/:id/microformats", %{conn: conn, bookmark: bookmark} do
      conn = get(conn, Routes.bookmark_path(conn, :microformats, bookmark.slug))
      assert html_response(conn, 200) =~ bookmark.title
    end
  end
end
