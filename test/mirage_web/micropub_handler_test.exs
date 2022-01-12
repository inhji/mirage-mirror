defmodule MirageWeb.MicropubHandlerTest do
  use MirageWeb.ConnCase

  describe "micropub" do
    test "sending a request to /micropub without payload will result in a 401", %{conn: conn} do
      conn = post(conn, "/indie/micropub", %{})
      assert json_response(conn, 401)
    end

    test "sending a like to /micropub will create a new like", %{conn: conn} do
      conn = post(conn, "/indie/micropub", %{"like-of" => ["http://google.de"]})
      assert json_response(conn, 301)
    end

    test "sending a bookmark to /micropub will create a new like", %{conn: conn} do
      conn = post(conn, "/indie/micropub", %{"bookmark-of" => ["http://google.de"]})
      assert json_response(conn, 301)
    end

    test "sending a note to /micropub will create a new like", %{conn: conn} do
      conn = post(conn, "/indie/micropub", %{"content" => ["duckin duck"]})
      assert json_response(conn, 301)
    end
  end
end
