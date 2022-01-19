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

  def microformats(conn, %{"id" => id}) do
    bookmark = Mirage.Bookmarks.get_bookmark!(id)

    mf2 =
      conn
      |> Routes.bookmark_url(:show, id)
      |> Microformats2.parse()

    render(conn, "microformats.html", bookmark: bookmark, microformats: inspect(mf2, pretty: true))
  end
end
