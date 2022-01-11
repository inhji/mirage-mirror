defmodule MirageWeb.ActivityPub.ActorView do
  use MirageWeb, :view

  def render("actor.json", %{user: user}) do
    actor_url = Routes.activity_pub_actor_url(MirageWeb.Endpoint, :actor)
    inbox_url = Routes.activity_pub_actor_url(MirageWeb.Endpoint, :inbox)

    %{
      "@context" => [
        "https://www.w3.org/ns/activitystreams",
        "https://w3id.org/security/v1"
      ],
      "id" => actor_url,
      "type" => "Person",
      "preferredUsername" => user.handle,
      "inbox" => inbox_url,
      "publicKey" => %{
        "id" => actor_url <> "#main-key",
        "owner" => actor_url,
        "publicKeyPem" => user.pub_key
      }
    }
  end

  def render("inbox.json", _params) do
    %{}
  end
end
