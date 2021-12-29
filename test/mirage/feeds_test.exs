defmodule Mirage.FeedsTest do
  use Mirage.DataCase

  alias Mirage.Feeds
  import Mirage.NotesFixtures
  import Mirage.AccountsFixtures

  describe "feeds" do
    setup [:create_note, :create_user]

    test "build_feed/4 builds a rss/atom feed from a list of notes", %{note: note, user: user} do
      {:ok, note} = Mirage.Notes.publish_note(note)

      feed = Feeds.render_feed("home", user)

      assert feed =~ user.email
      assert feed =~ note.content
      assert feed =~ note.slug
      assert feed =~ note.title
    end
  end
end
