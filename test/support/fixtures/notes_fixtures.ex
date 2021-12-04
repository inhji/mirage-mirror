defmodule Mirage.NotesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mirage.Notes` context.
  """

  import Mirage.ListsFixtures

  @doc """
  Generate a note.
  """
  def note_fixture(attrs \\ %{}) do
    list = list_fixture()

    {:ok, note} =
      attrs
      |> Enum.into(%{
        content: "some content",
        content_html: "some content_html",
        title: "some title",
        list_id: list.id
      })
      |> Mirage.Notes.create_note()

    note |> Mirage.Notes.preload_note()
  end
end
