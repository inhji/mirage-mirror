defmodule Mirage.Tags.TagSlug do
  @moduledoc """
  Note slug module
  """
  use EctoAutoslugField.Slug, from: :title, to: :slug
end
