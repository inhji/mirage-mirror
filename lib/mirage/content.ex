defmodule Mirage.Content do
  def list_updates() do
    Mirage.Notes.list_published_notes()
  end
end
