defmodule Mirage.TagUpdaterTest do
  use Mirage.DataCase

  import Mirage.NotesFixtures
  alias Mirage.Tags.TagUpdater

  describe "update_tags/2" do
    setup [:create_note]

    test "update_tags/2 with a comma-seperated string list updates a note with the given tags", %{
      note: note
    } do
      assert note.tags == []
      TagUpdater.update_tags(note, "foo")
      note = Mirage.Notes.get_note!(note.slug)
      assert Enum.count(note.tags) == 1
    end
  end
end
