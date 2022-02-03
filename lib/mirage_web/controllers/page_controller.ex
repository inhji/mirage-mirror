defmodule MirageWeb.PageController do
  use MirageWeb, :controller

  def index(conn, params) do
    page = Mirage.Content.list_updates(params)
    user = Mirage.Accounts.get_user()

    render(conn, "index.html",
      page_title: "Home",
      page: page,
      user: user,
      updates: page.entries,
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    )
  end

  def about(conn, _params) do
    user = Mirage.Accounts.get_user()

    render(conn, "about.html", page_title: "About", user: user)
  end
end
