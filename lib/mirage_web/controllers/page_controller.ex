defmodule MirageWeb.PageController do
  use MirageWeb, :controller

  def index(conn, _params) do
    user = Mirage.Accounts.get_user()
    updates = Mirage.Content.list_updates()

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
