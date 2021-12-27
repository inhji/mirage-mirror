defmodule Mirage.FeedsTest do
  use Mirage.DataCase

  alias Mirage.Feeds
  import Mirage.NotesFixtures

  describe "feeds" do
    setup [:create_note]

    test "build_feed/4 builds a rss/atom feed from a list of notes", %{note: note} do
      {:ok, note} = Mirage.Notes.publish_note(note)

      entries = [note]
      content_url = "http://some.url"
      feed_url = "http://some.url/feed"
      title = "Some Feed"

      feed = Feeds.build_feed(entries, content_url, feed_url, title)

      assert feed =~ title
      assert feed =~ content_url
      assert feed =~ feed_url
      assert feed =~ note.title
      assert feed =~ note.content
    end
  end
end
