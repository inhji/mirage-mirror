defmodule Mirage.Hooks do
  @moduledoc """
  Hooks are a way of executing additional functions or logic when entities are created.


  """

  require Logger

  def run({:ok, schema} = result, attrs, hooks) do
    Enum.each(hooks, fn hook ->
      info = Function.info(hook)
      Logger.info("Running #{info[:name]} for #{schema.slug}")
      hook.(schema, attrs)
    end)

    result
  end

  def run(result, _attrs, _hooks) do
    result
  end
end
