defmodule Mirage.Queries do
  @moduledoc """
  Adds constraints to a note query:

  - order_by
  - limit
  - search term
  - published
  - list
  """

  import Ecto.Query, warn: false
  import Mirage.Macros
  alias Mirage.Lists.List

  def where_published(query), do: where(query, [n], not is_nil(n.published_at))

  def where_unpublished(query), do: where(query, [n], is_nil(n.published_at))

  def where_in_list(query, nil), do: query

  def where_in_list(query, list_id) do
    query
    |> join(:inner, [n], l in List, on: [id: n.list_id])
    |> where([n], n.list_id == ^list_id)
  end

  def where_contains(query, search_string) do
    query
    |> where([n], contains(n.content, ^search_string))
    |> or_where([n], contains(n.title, ^search_string))
  end
end
