defmodule Mirage do
  @moduledoc """
  Mirage keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @user_agent Application.compile_env!(:mirage, [MirageWeb.Endpoint, :user_agent])

  def user_agent(), do: @user_agent
end
