defmodule MirageWeb.PageController do
  use MirageWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html",
      updates: Mirage.Notes.list_updates(limit: 5),
      articles: Mirage.Notes.list_articles(),
      user: Mirage.Accounts.get_user(),
      preview: false
    )
  end

  # def index(conn, params) do
  #   page = Mirage.Content.list_updates(params)
  #   user = Mirage.Accounts.get_user()

  #   render(conn, "index.html",
  #     page_title: "Home",
  #     page: page,
  #     user: user,
  #     updates: page.entries,
  #     page_number: page.page_number,
  #     page_size: page.page_size,
  #     total_pages: page.total_pages,
  #     total_entries: page.total_entries
  #   )
  # end
end
