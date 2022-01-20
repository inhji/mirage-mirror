defmodule MirageWeb.PageController do
  use MirageWeb, :controller

  def index(conn, _params) do
    user = Mirage.Accounts.get_user()

    notes = Mirage.Notes.list_published_notes()
    bookmarks = Mirage.Bookmarks.list_published_bookmarks()

    updates =
      Enum.sort(bookmarks ++ notes, fn item1, item2 ->
        NaiveDateTime.compare(item1.published_at, item2.published_at) == :gt
      end)

    render(conn, "index.html",
      page_title: "Home",
      user: user,
      updates: updates
    )
  end

  def about(conn, _params) do
    render(conn, "about.html", page_title: "About")
  end
end
