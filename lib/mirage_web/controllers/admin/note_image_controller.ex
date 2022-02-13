defmodule MirageWeb.Admin.NoteImageController do
  use MirageWeb, :controller

  alias Mirage.NoteImages
  alias Mirage.Notes.NoteImage

  plug :fetch_note

  def index(conn, _params) do
    note = conn.assigns.note
    note_images = NoteImages.list_note_images(note)
    render(conn, "index.html", note_images: note_images)
  end

  def new(conn, _params) do
    changeset = NoteImages.change_note_image(%NoteImage{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"note_image" => note_image_params}) do
    case NoteImages.create_note_image(note_image_params) do
      {:ok, note_image} ->
        conn
        |> put_flash(:info, "Note image created successfully.")
        |> redirect(to: Routes.admin_note_image_path(conn, :show, conn.assigns.note, note_image))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"image_id" => id}) do
    note_image = NoteImages.get_note_image!(id)
    render(conn, "show.html", note_image: note_image)
  end

  def edit(conn, %{"image_id" => id}) do
    note_image = NoteImages.get_note_image!(id)
    changeset = NoteImages.change_note_image(note_image)
    render(conn, "edit.html", note_image: note_image, changeset: changeset)
  end

  def update(conn, %{"image_id" => id, "note_image" => note_image_params}) do
    note_image = NoteImages.get_note_image!(id)

    case NoteImages.update_note_image(note_image, note_image_params) do
      {:ok, note_image} ->
        conn
        |> put_flash(:info, "Note image updated successfully.")
        |> redirect(to: Routes.admin_note_image_path(conn, :show, conn.assigns.note, note_image))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", note_image: note_image, changeset: changeset)
    end
  end

  def delete(conn, %{"image_id" => id}) do
    note_image = NoteImages.get_note_image!(id)
    {:ok, _note_image} = NoteImages.delete_note_image(note_image)

    conn
    |> put_flash(:info, "Note image deleted successfully.")
    |> redirect(to: Routes.admin_note_image_path(conn, :index, conn.assigns.note))
  end

  def fetch_note(%{params: %{"id" => note_slug}} = conn, _opts) do
    note = Mirage.Notes.get_note!(note_slug)
    assign(conn, :note, note)
  end
end
