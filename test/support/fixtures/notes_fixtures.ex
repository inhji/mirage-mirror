defmodule Mirage.NotesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mirage.Notes` context.
  """

  @doc """
  Generate a note.
  """
  def note_fixture(attrs \\ %{}) do
    {:ok, note} =
      attrs
      |> Enum.into(%{
        content: "some content",
        content_html: "some content_html",
        published_at: ~N[2021-11-27 14:08:00],
        slug: "some slug",
        title: "some title",
        viewed_at: ~N[2021-11-27 14:08:00],
        views: 42
      })
      |> Mirage.Notes.create_note()

    note
  end
end
