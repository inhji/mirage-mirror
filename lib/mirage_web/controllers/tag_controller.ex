defmodule MirageWeb.TagController do
  use MirageWeb, :controller

  def index(conn, _params) do
    tags = Mirage.Tags.list_tags()

    render(conn, "index.html", page_title: "Tags", tags: tags)
  end

  def show(conn, %{"id" => id}) do
    tag = Mirage.Tags.get_tag!(id)

    render(conn, "show.html", page_title: "Tag #{tag.title}", tag: tag)
  end
end
