defmodule Mirage.Macros do
  @moduledoc """
  Collection of macros
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
