defmodule MirageWeb.Admin.NoteController do
  use MirageWeb, :controller

  alias Mirage.Notes
  alias Mirage.Notes.Note

  @syndication_targets Application.compile_env!(:mirage, [:indie, :supported_targets])

  plug :assign_form_data

  def index(conn, _params) do
    notes = Notes.list_notes()
    render(conn, "index.html", notes: notes, page_title: "Notes")
  end

  def new(conn, _params) do
    changeset = Notes.change_note(%Note{})

    render(conn, "new.html",
      changeset: changeset,
      page_title: "New Note",
      tags: []
    )
  end

  def create(conn, %{"note" => note_params}) do
    case Notes.create_note_with_hooks(note_params) do
      {:ok, note} ->
        conn
        |> put_flash(:info, "Note created successfully.")
        |> redirect(to: Routes.admin_note_path(conn, :show, note))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html",
          changeset: changeset,
          page_title: "New Note",
          tags: []
        )
    end
  end

  def show(conn, %{"id" => id}) do
    note = Notes.get_note!(id)
    render(conn, "show.html", note: note, page_title: note.title)
  end

  def edit(conn, %{"id" => id}) do
    note = Notes.get_note!(id)
    changeset = Notes.change_note(note)

    render(conn, "edit.html",
      changeset: changeset,
      page_title: "Edit Note",
      note: note,
      tags: note.tags
    )
  end

  def update(conn, %{"id" => id, "note" => note_params}) do
    note = Notes.get_note!(id)

    case Notes.update_note_with_hooks(note, note_params) do
      {:ok, note} ->
        conn
        |> put_flash(:info, "Note updated successfully.")
        |> redirect(to: Routes.admin_note_path(conn, :show, note))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          changeset: changeset,
          page_title: "Edit Note",
          note: note,
          tags: note.tags
        )
    end
  end

  def publish(conn, %{"id" => id}) do
    note = Notes.get_note!(id)

    case Notes.publish_note(note) do
      {:ok, note} ->
        conn
        |> put_flash(:info, "Note published successfully.")
        |> redirect(to: Routes.admin_note_path(conn, :show, note))

      {:error, %Ecto.Changeset{} = _changeset} ->
        render(conn, "show.html", note: note)
    end
  end

  def unpublish(conn, %{"id" => id}) do
    note = Notes.get_note!(id)

    case Notes.unpublish_note(note) do
      {:ok, note} ->
        conn
        |> put_flash(:info, "Note unpublished successfully.")
        |> redirect(to: Routes.admin_note_path(conn, :show, note))

      {:error, %Ecto.Changeset{} = _changeset} ->
        render(conn, "show.html", note: note)
    end
  end

  def delete(conn, %{"id" => id}) do
    note = Notes.get_note!(id)
    {:ok, _note} = Notes.delete_note(note)

    conn
    |> put_flash(:info, "Note deleted successfully.")
    |> redirect(to: Routes.admin_note_path(conn, :index))
  end

  defp assign_form_data(conn, _opts) do
    lists =
      Mirage.Lists.list_lists()
      |> Enum.map(&Mirage.Lists.for_select/1)

    conn
    |> assign(:lists, lists)
    |> assign(:targets, @syndication_targets)
  end
end
