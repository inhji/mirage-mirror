defmodule Mirage.TagsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mirage.Tags` context.
  """

  @doc """
  Generate a tag.
  """
  def tag_fixture(attrs \\ %{}) do
    {:ok, tag} =
      attrs
      |> Enum.into(%{
        content: "some content",
        content_html: "some content_html",
        icon: "some icon",
        regex: "some regex",
        slug: "some slug",
        title: "some title"
      })
      |> Mirage.Tags.create_tag()

    tag |> Mirage.Tags.preload_tag()
  end
end
