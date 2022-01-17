defmodule MirageWeb.MicropubHandlerTest do
  use MirageWeb.ConnCase

  setup [:register_and_log_in_user]

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

  describe "create_post/2 with :note" do
    test "sending a name and content creates a note" do
      response = Mirage.Indie.MicropubHandler.create_post(:note, %{
        "name" => ["Some Title from Micropub #{System.unique_integer()}"],
        "content" => ["Some Content about the Indieweb"]
      })

      assert {:ok, :created, url} = response
      assert url =~ "/notes/"
    end

    test "sending only content creates a note" do
      response = Mirage.Indie.MicropubHandler.create_post(:note, %{
        "content" => ["Some more Content about the Indieweb"]
      })

      assert {:ok, :created, url} = response
      assert url =~ "/notes/"
    end
  end

  describe "create_post/2 with :bookmark" do
    test "sending a name and content creates a bookmark" do
      response = Mirage.Indie.MicropubHandler.create_post(:bookmark, %{
        "name" => ["Some Title from Micropub #{System.unique_integer()}"],
        "content" => ["Some Content about the Indieweb"],
        "url" => ["http://inhji.de"]
      })

      assert {:ok, :created, url} = response
      assert url =~ "/bookmarks/"
    end

    test "sending a bookmark creates a bookmark" do
      response = Mirage.Indie.MicropubHandler.create_post(:bookmark, %{
        "content" => ["Some more Content about the Indieweb"],
        "bookmark_of" => ["http://inhji.de"]
      })

      assert {:ok, :created, url} = response
      assert url =~ "/bookmarks/"
    end

    test "sending a like creates a bookmark" do
      response = Mirage.Indie.MicropubHandler.create_post(:bookmark, %{
        "content" => ["Some more Content about the Indieweb"],
        "like_of" => ["http://inhji.de"]
      })

      assert {:ok, :created, url} = response
      assert url =~ "/bookmarks/"
    end

    test "sending a repost creates a bookmark" do
      response = Mirage.Indie.MicropubHandler.create_post(:bookmark, %{
        "content" => ["Some more Content about the Indieweb"],
        "repost_of" => ["http://inhji.de"]
      })

      assert {:ok, :created, url} = response
      assert url =~ "/bookmarks/"
    end
  end
end
