defmodule MirageWeb.ListController do
  use MirageWeb, :controller

  def show(conn, %{"id" => id}) do
    list = Mirage.Lists.get_list!(id)

    render(conn, "show.html", page_title: "List #{list.title}", list: list)
  end
end
