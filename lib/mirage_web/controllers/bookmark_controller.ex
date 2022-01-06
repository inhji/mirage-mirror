defmodule MirageWeb.BookmarkController do
  use MirageWeb, :controller

  def index(conn, _params) do
    bookmarks = Mirage.Bookmarks.list_bookmarks()
    render(conn, "index.html", bookmarks: bookmarks, page_title: "Bookmarks")
  end

  def show(conn, %{"id" => id}) do
    bookmark = Mirage.Bookmarks.get_bookmark!(id)
    render(conn, "show.html", bookmark: bookmark, page_title: bookmark.title)
  end
end