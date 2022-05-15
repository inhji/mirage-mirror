defmodule Mirage.NotesTest do
  use Mirage.DataCase

  import Mirage.NotesFixtures
  import Mirage.ListsFixtures
  import Mirage.AccountsFixtures
  alias Mirage.Notes
  alias Mirage.Notes.Note

  describe "notes" do
    setup :create_user

    @invalid_attrs %{
      content: nil,
      title: nil
    }

    test "list_notes/0 returns all notes" do
      note = note_fixture()
      assert Notes.list_notes() == [note]
    end

    test "search_notes/1 returns a list of results matching the search query" do
      note = note_fixture()
      assert Notes.search_notes(note.title) == [note]
      assert Notes.search_notes("some") == [note]
      assert Notes.search_notes("content") == [note]
      assert Notes.search_notes("tent") == [note]
      # assert Notes.search_notes("me") == [note]
      # assert String.slice(note.title, 0..5) |> Notes.search_notes() == [note]
      # assert String.slice(note.title, 1..5) |> Notes.search_notes() == [note]
    end

    test "get_note!/1 returns the note with given id" do
      note = note_fixture()
      assert Notes.get_note!(note.slug) == note
    end

    test "create_note/1 with valid data creates a note" do
      list = list_fixture()
      user = user_fixture()

      valid_attrs = %{
        title: "some title",
        content: "some content",
        list_id: list.id,
        user_id: user.id
      }

      assert {:ok, %Note{} = note} = Notes.create_note(valid_attrs)
      assert note.content == "some content"
      assert note.title == "some title"
    end

    test "create_note/1 with valid data creates a slug" do
      list = list_fixture()
      user = user_fixture()

      valid_attrs = %{
        title: "some title",
        content: "some content",
        list_id: list.id,
        user_id: user.id
      }

      assert {:ok, %Note{} = note} = Notes.create_note(valid_attrs)
      assert note.title == "some title"
      assert note.slug == "some-title"
    end

    test "create_note/1 with valid data renders markdown" do
      list = list_fixture()
      user = user_fixture()

      valid_attrs = %{
        title: "some title",
        content: "some **content**",
        list_id: list.id,
        user_id: user.id
      }

      assert {:ok, %Note{} = note} = Notes.create_note(valid_attrs)
      assert note.content_html =~ "<strong>content</strong>"
    end

    test "create_note/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Notes.create_note(%{
                 content: nil,
                 title: "some updated title"
               })

      assert {:error, %Ecto.Changeset{}} =
               Notes.create_note(%{
                 content: "some updated content",
                 title: nil
               })

      assert {:error, %Ecto.Changeset{}} =
               Notes.create_note(%{
                 content: nil,
                 title: nil
               })
    end

    test "create_note/1 with emoji in title returns error changeset" do
      list = list_fixture()
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Notes.create_note(%{
                 content: "test",
                 title: "🤒 some title with emoji",
                 list_id: list.id,
                 user_id: user.id
               })
    end

    test "update_note/2 with valid data updates the note" do
      note = note_fixture()

      update_attrs = %{
        content: "some updated content",
        title: "some updated title"
      }

      assert {:ok, %Note{} = note} = Notes.update_note(note, update_attrs)
      assert note.content == "some updated content"
      assert note.title == "some updated title"
    end

    test "update_note/2 with invalid data returns error changeset" do
      note = note_fixture()
      assert {:error, %Ecto.Changeset{}} = Notes.update_note(note, @invalid_attrs)
      assert note == Notes.get_note!(note.slug)
    end

    test "publish_note/1 publishes a note by setting published_at" do
      note = note_fixture()
      assert {:ok, %Note{} = note} = Notes.publish_note(note)
      assert not is_nil(note.published_at)
    end

    test "unpublish_note/1 unpublishes a note by setting published_at to nil" do
      note = note_fixture()
      assert {:ok, %Note{} = note} = Notes.unpublish_note(note)
      assert is_nil(note.published_at)
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
