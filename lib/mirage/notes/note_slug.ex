defmodule Mirage.Notes.NoteSlug do
  use EctoAutoslugField.Slug, from: :title, to: :slug
end
