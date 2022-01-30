defmodule Mirage.NoteSyndications do
  @moduledoc """
  The NoteSyndications context
  """

  import Ecto.Query, warn: false
  alias Mirage.Repo
  alias Mirage.Notes.NoteSyndication

  def get_syndication(note, type) do
    NoteSyndication
    |> where(note_id: ^note.id, type: ^type)
    |> Repo.one()
  end

  def list_syndications(note) do
    NoteSyndication
    |> where(note_id: ^note.id)
    |> Repo.all()
  end

  def create_syndication(attrs \\ %{}) do
    %NoteSyndication{}
    |> NoteSyndication.changeset(attrs)
    |> Repo.insert()
  end

  def delete_syndication(%NoteSyndication{} = note_syndication) do
    Repo.delete(note_syndication)
  end
end
