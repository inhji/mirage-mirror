defmodule MirageWeb.SiteInfo do
  import Plug.Conn, only: [assign: 3]

  @doc """
  Assigns the pages of the site to the conn-object.
  Returns an empty list if no pages are found.
  """
  def fetch_pages(conn, _opts) do
    pages = Mirage.Notes.list_pages()
    assign(conn, :pages, pages)
  end
end
