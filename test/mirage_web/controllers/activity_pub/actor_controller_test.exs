defmodule MirageWeb.ActivityPub.ActorControllerTest do
  use MirageWeb.ConnCase

  setup :register_and_log_in_user

  describe "actor" do
    test "returns the user in their actor representation", %{conn: conn, user: user} do
      conn = get(conn, Routes.activity_pub_actor_path(conn, :actor))

      assert actor_profile = json_response(conn, 200)
      assert actor_profile["preferredUsername"] == user.handle
      assert actor_profile["publicKey"]["publicKeyPem"] == user.pub_key
    end
  end
end
