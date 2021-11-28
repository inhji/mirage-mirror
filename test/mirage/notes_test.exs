defmodule Mirage.NotesTest do
  use Mirage.DataCase

  alias Mirage.Notes

  describe "notes" do
    alias Mirage.Notes.Note

    import Mirage.NotesFixtures

    @invalid_attrs %{content: nil, content_html: nil, published_at: nil, slug: nil, title: nil, viewed_at: nil, views: nil}

    test "list_notes/0 returns all notes" do
      note = note_fixture()
      assert Notes.list_notes() == [note]
    end

    test "get_note!/1 returns the note with given id" do
      note = note_fixture()
      assert Notes.get_note!(note.id) == note
    end

    test "create_note/1 with valid data creates a note" do
      valid_attrs = %{content: "some content", content_html: "some content_html", published_at: ~N[2021-11-27 14:08:00], slug: "some slug", title: "some title", viewed_at: ~N[2021-11-27 14:08:00], views: 42}

      assert {:ok, %Note{} = note} = Notes.create_note(valid_attrs)
      assert note.content == "some content"
      assert note.content_html == "some content_html"
      assert note.published_at == ~N[2021-11-27 14:08:00]
      assert note.slug == "some slug"
      assert note.title == "some title"
      assert note.viewed_at == ~N[2021-11-27 14:08:00]
      assert note.views == 42
    end

    test "create_note/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Notes.create_note(@invalid_attrs)
    end

    test "update_note/2 with valid data updates the note" do
      note = note_fixture()
      update_attrs = %{content: "some updated content", content_html: "some updated content_html", published_at: ~N[2021-11-28 14:08:00], slug: "some updated slug", title: "some updated title", viewed_at: ~N[2021-11-28 14:08:00], views: 43}

      assert {:ok, %Note{} = note} = Notes.update_note(note, update_attrs)
      assert note.content == "some updated content"
      assert note.content_html == "some updated content_html"
      assert note.published_at == ~N[2021-11-28 14:08:00]
      assert note.slug == "some updated slug"
      assert note.title == "some updated title"
      assert note.viewed_at == ~N[2021-11-28 14:08:00]
      assert note.views == 43
    end

    test "update_note/2 with invalid data returns error changeset" do
      note = note_fixture()
      assert {:error, %Ecto.Changeset{}} = Notes.update_note(note, @invalid_attrs)
      assert note == Notes.get_note!(note.id)
    end

    test "delete_note/1 deletes the note" do
      note = note_fixture()
      assert {:ok, %Note{}} = Notes.delete_note(note)
      assert_raise Ecto.NoResultsError, fn -> Notes.get_note!(note.id) end
    end

    test "change_note/1 returns a note changeset" do
      note = note_fixture()
      assert %Ecto.Changeset{} = Notes.change_note(note)
    end
  end
end
