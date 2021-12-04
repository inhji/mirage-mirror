defmodule Mirage.ListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mirage.Lists` context.
  """

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    {:ok, list} =
      attrs
      |> Enum.into(%{
        content: "some content",
        display_type: :list,
        published_at: ~N[2021-12-03 08:47:00],
        title: "some title",
        viewed_at: ~N[2021-12-03 08:47:00],
        views: 42
      })
      |> Mirage.Lists.create_list()

    list
  end
end
