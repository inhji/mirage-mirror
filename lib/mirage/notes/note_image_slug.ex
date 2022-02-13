defmodule Mirage.Notes.NoteImageSlug do
  @moduledoc """
  NoteImage slug module
  """
  use EctoAutoslugField.Slug, from: :title, to: :slug
end
