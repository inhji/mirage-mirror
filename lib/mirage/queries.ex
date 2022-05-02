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

  def where_published(query), do: where(query, [n], not is_nil(n.published_at))

  def where_unpublished(query), do: where(query, [n], is_nil(n.published_at))

  def order_by_query(query, opts) do
    case opts["order_by"] do
      "published_at_desc" ->
        query |> order_by([n], desc_nulls_last: n.published_at)

      "published_at_asc" ->
        query |> order_by([n], asc_nulls_last: n.published_at)

      "inserted_at_desc" ->
        query |> order_by([n], desc: n.inserted_at)

      "inserted_at_asc" ->
        query |> order_by([n], asc: n.inserted_at)

      _ ->
        query
    end
  end

  def limit_query(query, opts) do
    case opts["limit"] do
      nil ->
        query

      "all" ->
        query

      limit ->
        query |> limit(^limit)
    end
  end

  def search_query(query, opts) do
    case opts["search_query"] do
      "" ->
        query

      search_query ->
        str = "%#{search_query}%"
        query |> where([n], ilike(n.title, ^str))
    end
  end

  def published_query(query, opts) do
    case opts["show_published"] do
      "published" -> query |> where([n], not is_nil(n.published_at))
      "unpublished" -> query |> where([n], is_nil(n.published_at))
      _ -> query
    end
  end

  def list_query(query, opts) do
    case opts["show_list"] do
      "all" -> query
      nil -> query
      list_id -> query |> where([n], n.list_id == ^list_id)
    end
  end
end
