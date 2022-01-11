defmodule Mirage.Hooks do
  @moduledoc """
  Hooks are a way of executing additional functions or logic when entities are created.


  """

  require Logger

  def run({:ok, schema} = result, attrs, hooks) do
    Enum.each(hooks, fn hook ->
      Logger.info("Running #{inspect(hook)} for #{schema.slug}")
      hook.(schema, attrs)
    end)

    result
  end

  def run(result, _attrs, _hooks) do
    result
  end
end
