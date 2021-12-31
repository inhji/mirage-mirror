defmodule MirageWeb.FeedController do
  use MirageWeb, :controller
  import Mirage.Feeds, only: [render_feed: 2]

  def index(conn, _params) do
    render(conn, "index.html", page_title: "Feeds")
  end

  def show(conn, %{"id" => feed_id}) do
    user = Mirage.Accounts.get_user!()
    feed_xml = render_feed(feed_id, user)

    conn
    |> put_resp_content_type("application/xml")
    |> send_resp(200, feed_xml)
  end
end
