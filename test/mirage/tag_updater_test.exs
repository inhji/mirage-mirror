defmodule Mirage.TagUpdaterTest do
  use Mirage.DataCase

  import Mirage.NotesFixtures
  alias Mirage.Tags.TagUpdater

  describe "update_tags/2" do
    setup [:create_note]

    test "with a single tag updates a note with the given tag", %{note: note} do
      assert note.tags == []
      TagUpdater.update_tags(note, "foo")
      note = Mirage.Notes.get_note!(note.slug)
      assert Enum.count(note.tags) == 1
    end

    test "with a list of new tags replaces exisiting tags", %{note: note} do
      assert note.tags == []

      TagUpdater.update_tags(note, "foo")
      note = Mirage.Notes.get_note!(note.slug)
      assert Enum.count(note.tags) == 1

      TagUpdater.update_tags(note, ["bar", "baz"])
      note = Mirage.Notes.get_note!(note.slug)
      assert Enum.count(note.tags) == 2
    end

    test "with a map representing the attributes replaces existing tags", %{note: note} do
      assert note.tags == []

      TagUpdater.update_tags(note, %{tags_string: "foo,bar,baz"})
      note = Mirage.Notes.get_note!(note.slug)
      assert Enum.count(note.tags) == 3
    end
  end
end
