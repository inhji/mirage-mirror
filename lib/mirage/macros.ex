defmodule Mirage.Macros do
  @moduledoc """
  Collection of macros
  """

  @doc """
  A query macro for text search with the `pg_trgm` Postgres extension.
  """
  defmacro contains(content, search_term) do
    quote do
      fragment(
        "LOWER(?) %> LOWER(?)",
        unquote(content),
        unquote(search_term)
      )
    end
  end
end
