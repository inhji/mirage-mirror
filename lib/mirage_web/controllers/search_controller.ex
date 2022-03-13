defmodule MirageWeb.SearchController do
  use MirageWeb, :controller

  def index(conn, %{"for" => query}) do
    notes = Mirage.Notes.search_notes(query)
    render(conn, "index.html", query: query, notes: notes)
  end

  def index(conn, _params) do
    render(conn, "index.html", query: nil)
  end
end
