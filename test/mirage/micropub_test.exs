defmodule Mirage.MicropubTest do
  use MirageWeb.ConnCase
  use Oban.Testing, repo: Mirage.Repo

  describe "create_post/2" do
    setup :register_and_log_in_user

    test "sending a name and content creates a note" do
      {:ok, note} =
        Mirage.Indie.Micropub.create_post(%{
          "name" => ["Some Title from Micropub #{System.unique_integer()}"],
          "content" => ["Some Content about the Indieweb"]
        })

      assert note.title =~ "Some Title from Micropub"
    end

    test "sending only content creates a note with numeric title" do
      {:ok, note} =
        Mirage.Indie.Micropub.create_post(%{
          "content" => ["Some more Content about the Indieweb"]
        })

      assert note.title |> String.to_integer() |> is_number()
      assert note.content =~ "Some more Content about the Indieweb"
    end

    test "sending a name and content creates a bookmark" do
      {:ok, note} =
        Mirage.Indie.Micropub.create_post(
          %{
            "name" => ["Some Title from Micropub #{System.unique_integer()}"],
            "content" => ["Some more Content about the Indieweb"],
            "bookmark-of" => ["https://inhji.de"]
          },
          :bookmark
        )

      assert note.content =~ "Some more Content about the Indieweb"
      assert note.bookmark_of == "https://inhji.de"
      assert note.url == "https://inhji.de"
      assert note.url_type == "bookmark_of"
    end

    test "sending a like creates a like" do
      {:ok, note} =
        Mirage.Indie.Micropub.create_post(
          %{
            "content" => ["Some more Content about the Indieweb"],
            "like-of" => ["https://inhji.de"]
          },
          :like
        )

      assert note.content =~ "❤️"
      assert note.like_of == "https://inhji.de"
      assert note.url == "https://inhji.de"
      assert note.url_type == "like_of"
    end

    test "sending a like with syndication targets creates a like and syndicates it" do
      {:ok, note} =
        Mirage.Indie.Micropub.create_post(
          %{
            "content" => ["Some more Content about the Indieweb"],
            "like-of" => ["https://inhji.de"],
            "mp-syndicate-to" => ["mastodon"]
          },
          :like
        )

      note = Mirage.Notes.preload_note(note)

      assert note.content =~ "❤️"
      assert note.like_of == "https://inhji.de"
      assert note.url == "https://inhji.de"
      assert note.url_type == "like_of"
      assert Enum.empty?(note.syndications) == false

      worker_args = %{"id" => note.id, "type" => "note"}
      assert_enqueued(worker: Mirage.Syndication.MastodonWorker, args: worker_args)
    end
  end
end
