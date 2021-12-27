defmodule Mirage.NotesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mirage.Notes` context.
  """

  import Mirage.ListsFixtures
  import Mirage.AccountsFixtures

  @doc """
  Generate a note.
  """
  def note_fixture(attrs \\ %{}) do
    title = "list-#{Mirage.Helper.random_string()}"
    list = list_fixture(title: title)
    user = user_fixture()

    {:ok, note} =
      attrs
      |> Enum.into(%{
        content: "some content",
        content_html: "some content_html",
        title: "some title",
        list_id: list.id,
        user_id: user.id
      })
      |> Mirage.Notes.create_note()

    note |> Mirage.Notes.preload_note()
  end

  def create_note(_) do
    note = note_fixture()
    %{note: note}
  end
end
