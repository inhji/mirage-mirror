defmodule MirageWeb.ActivityPub.ActorController do
  use MirageWeb, :controller

  def actor(conn, _params) do
    user = Mirage.Accounts.get_user()
    render(conn, "actor.json", user: user)
  end

  def inbox(conn, _params) do
    render(conn, "inbox.json")
  end
end
