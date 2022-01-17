defmodule Mirage.ListsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mirage.Lists` context.
  """

  import Mirage.Factory

  @doc """
  Generate a list.
  """
  def list_fixture(attrs \\ %{}) do
    insert(:list, attrs) 
    |> Mirage.Lists.preload_list()
  end

  def create_list(_) do
    list = list_fixture()
    %{list: list}
  end
end
