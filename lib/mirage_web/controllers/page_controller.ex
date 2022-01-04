defmodule MirageWeb.PageController do
  use MirageWeb, :controller

  def index(conn, _params) do
    notes = Mirage.Notes.list_published_notes()
    render(conn, "index.html", page_title: "Home", notes: notes)
  end

  def about(conn, _params) do
    user = Mirage.Accounts.get_user()
    render(conn, "about.html", page_title: "About", user: user)
  end
end
