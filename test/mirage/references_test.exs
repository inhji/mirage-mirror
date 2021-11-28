defmodule Mirage.ReferencesTest do
  use Mirage.DataCase

  alias Mirage.Notes
  alias Mirage.Notes.Note

  setup do
    {:ok, %Note{} = note1} =
      Notes.create_note(%{title: "some note", content: "this does not have a link yet"})

    {:ok, %Note{} = note2} =
      Notes.create_note(%{title: "some other note", content: "this does not have a link yet"})

    %{note1: note1, note2: note2}
  end

  describe "get_references" do
    test "get_references/1 finds self references", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{content: "this is a link to [[some-note]]"})

      assert [{"[[some-note]]", "some-note", "some-note"}] =
               Mirage.References.get_references(note1.content)
    end

    test "get_references/1 finds self references with title", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{content: "this is a link to [[some-note|Some Note]]"})

      assert [{"[[some-note|Some Note]]", "some-note", "Some Note"}] =
               Mirage.References.get_references(note1.content)
    end

    test "get_references/1 finds references to other notes", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{
                 content: "this is a link to [[some-other-note|Some other note]]"
               })

      assert [{"[[some-other-note|Some other note]]", "some-other-note", "Some other note"}] =
               Mirage.References.get_references(note1.content)
    end
  end

  describe "replace_references" do
    test "replace_references/2 replaces a self-reference", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{content: "this is a link to [[some-note]]"})

      assert "this is a link to [some-note](/notes/some-note)" =
               Mirage.References.replace_references(note1.content)
    end

    test "replace_references/2 replaces a self-reference with title", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{content: "this is a link to [[some-note|A Title]]"})

      assert "this is a link to [A Title](/notes/some-note)" =
               Mirage.References.replace_references(note1.content)
    end

    test "replace_references/2 replaces references to other notes", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{content: "this is a link to [[some-other-note]]"})

      assert "this is a link to [some-other-note](/notes/some-other-note)" =
               Mirage.References.replace_references(note1.content)
    end

    test "replace_references/2 replaces references to other notes with title", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{
                 content: "this is a link to [[some-other-note|Another title]]"
               })

      assert "this is a link to [Another title](/notes/some-other-note)" =
               Mirage.References.replace_references(note1.content)
    end
  end
end
