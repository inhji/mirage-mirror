defmodule Mirage.ReferencesTest do
  use Mirage.DataCase

  alias Mirage.Notes
  alias Mirage.Notes.Note
  import Mirage.NotesFixtures

  import Mirage.References,
    only: [
      get_references: 1,
      replace_references: 1,
      get_reference_ids: 1,
      get_reference_ids: 2
    ]

  setup do
    note1 = note_fixture(title: "some note")
    note2 = note_fixture(title: "some other note")
    %{note1: note1, note2: note2}
  end

  describe "get_references" do
    test "get_references/1 finds references" do
      assert [{"[[test]]", "note", "test", "test"}] ==
               get_references("this is a [[test]]")

      assert [{"[[test|Some Title]]", "note", "test", "Some Title"}] ==
               get_references("this is a [[test|Some Title]]")

      assert [{"[[tag:test]]", "tag", "test", "test"}] ==
               get_references("this is a [[tag:test]]")

      assert [{"[[list:test]]", "list", "test", "test"}] ==
               get_references("this is a [[list:test]]")

      assert [{"[[list:test|Some Title]]", "list", "test", "Some Title"}] ==
               get_references("this is a [[list:test|Some Title]]")
    end

    test "get_references/1 finds self references" do
      str = "this is a link to [[some-note]]"
      result = [{"[[some-note]]", "note", "some-note", "some-note"}]

      assert result == get_references(str)
    end

    test "get_references/1 finds self references with title" do
      str = "this is a link to [[some-note|Some Note]]"
      result = [{"[[some-note|Some Note]]", "note", "some-note", "Some Note"}]

      assert result == get_references(str)
    end

    test "get_references/1 finds references to other notes" do
      str = "this is a link to [[some-other-note|Some other note]]"

      result = [
        {"[[some-other-note|Some other note]]", "note", "some-other-note", "Some other note"}
      ]

      assert result == get_references(str)
    end

    test "get_references/1 finds references to a list" do
      str = "this is a link to [[list:some-list|Some list]]"
      result = [{"[[list:some-list|Some list]]", "list", "some-list", "Some list"}]

      assert result == get_references(str)
    end
  end

  describe "replace_references" do
    test "replace_references/2 replaces a self-reference", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{content: "this is a link to [[some-note]]"})

      assert "this is a link to [some-note](/notes/some-note)" ==
               replace_references(note1.content)
    end

    test "replace_references/2 replaces a self-reference with title", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{content: "this is a link to [[some-note|A Title]]"})

      assert "this is a link to [A Title](/notes/some-note)" ==
               replace_references(note1.content)
    end

    test "replace_references/2 replaces references to other notes", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{content: "this is a link to [[some-other-note]]"})

      assert "this is a link to [some-other-note](/notes/some-other-note)" ==
               replace_references(note1.content)
    end

    test "replace_references/2 replaces references to other notes with title", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{
                 content: "this is a link to [[some-other-note|Another title]]"
               })

      assert "this is a link to [Another title](/notes/some-other-note)" ==
               replace_references(note1.content)
    end

    test "replace_references/2 replaces references to a list", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{
                 content: "this is a link to [[list:some-list|Another title]]"
               })

      assert "this is a link to [Another title](/listed-in/some-list)" ==
               replace_references(note1.content)
    end
  end

  describe "get_reference_ids" do
    test "get_reference_ids/1" do
      ids = get_reference_ids("this is a [[test]]")
      assert ids == ["test"]
    end
  end
end
