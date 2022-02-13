defmodule Mirage.NoteImages do
  @moduledoc """
  The NoteImage context
  """

  import Ecto.Query, warn: false
  alias Mirage.Repo
  alias Mirage.Notes.{Note, NoteImage}

  def list_note_images(%Note{id: id}) do
    NoteImage
    |> where(note_id: ^id)
    |> Repo.all()
  end

  def get_note_image!(slug),
    do: Repo.get_by!(NoteImage, slug: slug)

  def create_note_image(attrs \\ %{}) do
    %NoteImage{}
    |> NoteImage.changeset(attrs)
    |> Repo.insert()
  end

  def update_note_image(%NoteImage{} = note_image, attrs) do
    note_image
    |> NoteImage.changeset(attrs)
    |> Repo.update()
  end

  def delete_note_image(%NoteImage{} = note_image) do
    Repo.delete(note_image)
  end

  def change_note_image(%NoteImage{} = note_image, attrs \\ %{}) do
    NoteImage.changeset(note_image, attrs)
  end
end
