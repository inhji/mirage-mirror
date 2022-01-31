defmodule Mirage.NoteHooksTest do
  use Mirage.DataCase
  use Oban.Testing, repo: Mirage.Repo

  import Mirage.NotesFixtures

  describe "note_hooks" do
    setup [:create_note]

    test "update_tags/2 updates a note's tags", %{note: note} do
      {:ok, updated_note} = Mirage.Notes.update_note_with_hooks(note, %{tags_string: "foo,bar"})
      assert is_nil(note.published_at)
      assert not is_nil(updated_note.tags)
    end

    test "create_syndications/2 creates initial syndication objects", %{note: note} do
      {:ok, _updated_note} =
        Mirage.Notes.update_note_with_hooks(note, %{
          "syndication_targets" => ["mastodon"]
        })

      updated_note = Mirage.Notes.get_note!(note.slug)

      assert Enum.empty?(note.syndications)
      assert [%Mirage.Notes.NoteSyndication{type: :mastodon}] = updated_note.syndications
    end

    test "send_webmentions/2 runs the webmention_worker", %{note: note} do
      {:ok, updated_note} = Mirage.Notes.update_note(note, %{content: "Hello https://inhji.de"})
      {:ok, _published_note} = Mirage.Notes.publish_note(updated_note)

      assert_enqueued(worker: Mirage.Indie.WebmentionWorker, args: %{"id" => note.id})
    end

    test "syndicate_to/2 runs the mastodon worker", %{note: note} do
      {:ok, updated_note} =
        Mirage.Notes.update_note_with_hooks(note, %{"syndication_targets" => ["mastodon"]})

      {:ok, _published_note} = Mirage.Notes.publish_note(updated_note)

      assert_enqueued(
        worker: Mirage.Syndication.MastodonWorker,
        args: %{"id" => note.id, "type" => "note"}
      )
    end
  end
end
