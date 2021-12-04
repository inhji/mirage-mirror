defmodule Mirage.ReferencesTest do
  use Mirage.DataCase

  alias Mirage.Notes
  alias Mirage.Notes.Note
  import Mirage.ListsFixtures
  import Mirage.References, only: [get_references: 1, replace_references: 1]

  setup do
    list = list_fixture()

    {:ok, %Note{} = note1} =
      Notes.create_note(%{
        title: "some note",
        content: "this does not have a link yet",
        list_id: list.id
      })

    {:ok, %Note{} = note2} =
      Notes.create_note(%{
        title: "some other note",
        content: "this does not have a link yet",
        list_id: list.id
      })

    %{note1: note1, note2: note2}
  end

  describe "get_references" do
    test "get_references/1 finds references" do
      assert [{"[[test]]", "", "test", "test"}] ==
               get_references("this is a [[test]]")

      assert [{"[[test|Some Title]]", "", "test", "Some Title"}] ==
               get_references("this is a [[test|Some Title]]")

      assert [{"[[tag:test]]", "tag", "test", "test"}] ==
               get_references("this is a [[tag:test]]")

      assert [{"[[list:test]]", "list", "test", "test"}] ==
               get_references("this is a [[list:test]]")

      assert [{"[[list:test|Some Title]]", "list", "test", "Some Title"}] ==
               get_references("this is a [[list:test|Some Title]]")
    end

    test "get_references/1 finds self references", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{content: "this is a link to [[some-note]]"})

      assert [{"[[some-note]]", "", "some-note", "some-note"}] ==
               get_references(note1.content)
    end

    test "get_references/1 finds self references with title", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{content: "this is a link to [[some-note|Some Note]]"})

      assert [{"[[some-note|Some Note]]", "", "some-note", "Some Note"}] ==
               get_references(note1.content)
    end

    test "get_references/1 finds references to other notes", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{
                 content: "this is a link to [[some-other-note|Some other note]]"
               })

      assert [{"[[some-other-note|Some other note]]", "", "some-other-note", "Some other note"}] ==
               get_references(note1.content)
    end
  end

  describe "replace_references" do
    test "replace_references/2 replaces a self-reference", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{content: "this is a link to [[some-note]]"})

      assert "this is a link to [some-note](/admin/notes/some-note)" ==
               replace_references(note1.content)
    end

    test "replace_references/2 replaces a self-reference with title", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{content: "this is a link to [[some-note|A Title]]"})

      assert "this is a link to [A Title](/admin/notes/some-note)" ==
               replace_references(note1.content)
    end

    test "replace_references/2 replaces references to other notes", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{content: "this is a link to [[some-other-note]]"})

      assert "this is a link to [some-other-note](/admin/notes/some-other-note)" ==
               replace_references(note1.content)
    end

    test "replace_references/2 replaces references to other notes with title", %{note1: note1} do
      assert {:ok, %Note{} = note1} =
               Notes.update_note(note1, %{
                 content: "this is a link to [[some-other-note|Another title]]"
               })

      assert "this is a link to [Another title](/admin/notes/some-other-note)" ==
               replace_references(note1.content)
    end
  end
end
