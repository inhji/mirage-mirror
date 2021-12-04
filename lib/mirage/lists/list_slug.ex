defmodule Mirage.Lists.ListSlug do
  @moduledoc """
  Note slug module
  """
  use EctoAutoslugField.Slug, from: :title, to: :slug
end
