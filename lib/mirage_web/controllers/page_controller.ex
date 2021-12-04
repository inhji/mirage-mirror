defmodule MirageWeb.PageController do
  use MirageWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", page_title: "Home")
  end

  def theme(conn, _params) do
    render(conn, "theme.html", page_title: "Theme Selector")
  end
end
