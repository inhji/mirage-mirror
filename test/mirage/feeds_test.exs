defmodule Mirage.FeedsTest do
  use Mirage.DataCase

  alias Mirage.Feeds
  import Mirage.NotesFixtures
  import Mirage.AccountsFixtures

  describe "feeds" do
    setup [:create_user]

    test "build_feed/4 builds a rss/atom feed from a list of notes", %{user: user} do
      note = note_fixture(%{list_id: user.microblog_list_id})

      {:ok, note} = Mirage.Notes.publish_note(note)

      feed = Feeds.render_feed("notes", user)

      assert feed =~ user.email
      assert feed =~ note.content
      assert feed =~ note.slug
      assert feed =~ note.title
    end
  end

  describe "feeds without user" do
    test "build_feed/4 returns nil if no user exists" do
      feed = Feeds.render_feed("notes", nil)

      assert is_nil(feed)
    end
  end
end
