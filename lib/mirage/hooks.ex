defmodule Mirage.Hooks do
  @moduledoc """
  Hooks are a way of executing additional functions or logic when entities are created.


  """

  require Logger

  def run({:ok, schema} = result, attrs, hooks, result_setup) do
    Enum.each(hooks, fn hook ->
      info = Function.info(hook)
      Logger.info("Running #{info[:name]} for #{schema.slug}")
      schema = result_setup.(schema)
      hook.(schema, attrs)
    end)

    result
  end

  def run(result, _attrs, _hooks, _result_setup) do
    result
  end
end
