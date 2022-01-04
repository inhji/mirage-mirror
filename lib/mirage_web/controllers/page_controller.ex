defmodule MirageWeb.PageController do
  use MirageWeb, :controller

  def index(conn, _params) do
    user = Mirage.Accounts.get_user()
    notes = Mirage.Notes.list_published_notes()
    render(conn, "index.html", page_title: "Home", notes: notes, user: user)
  end

  def about(conn, _params) do
    render(conn, "about.html", page_title: "About")
  end
end
