defmodule MirageWeb.SiteInfo do
  import Plug.Conn, only: [assign: 3]

  @doc """
  Assigns the pages of the site to the conn-object.
  Returns an empty list if no pages are found.
  """
  def fetch_pages(conn, _opts) do
    user = Mirage.Accounts.get_user()

    pages =
      if user do
        Mirage.Notes.list_notes(
          published: true,
          list: user.page_list_id
        )
      else
        []
      end

    assign(conn, :pages, pages)
  end
end
