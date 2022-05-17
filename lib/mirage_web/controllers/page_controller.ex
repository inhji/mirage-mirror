defmodule MirageWeb.PageController do
  use MirageWeb, :controller

  def index(conn, _params) do
    user = Mirage.Accounts.get_user()

    render(conn, "index.html",
      updates:
        Mirage.Notes.list_notes(
          limit: 5,
          published: true,
          list: user.microblog_list_id,
          preload: true
        ),
      articles:
        Mirage.Notes.list_notes(
          published: true,
          limit: 5,
          list: user.article_list_id,
          preload: true
        ),
      user: user,
      preview: false
    )
  end
end
