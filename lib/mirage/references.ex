defmodule Mirage.References do
  @moduledoc """
  Finds and replaces references to entities in a string
  """

  alias MirageWeb.Router.Helpers, as: Routes

  @hashid_reference_regex ~r/\[\[(?:(?<type>list|tag):)?(?<id>[\d\w-]+)(?:\|(?<title>[\w\d\s']+))?\]\]/

  @doc """
  Returns a list of references in the string
  """
  def get_references(string) do
    @hashid_reference_regex
    |> Regex.scan(string, capture: :all)
    |> Enum.map(&map_to_tuple/1)
  end

  @doc """
  Finds and replaces references with the matching url
  """
  def replace_references(string) do
    string
    |> get_references()
    |> Enum.reduce(string, fn {placeholder, type, slug, title}, s ->
      String.replace(s, placeholder, get_link(type, slug, title))
    end)
  end

  defp get_link(type, slug, title) do
    path =
      case type do
        "tag" ->
          "/nothing"

        "list" ->
          "/nothing"

        _ ->
          Routes.admin_note_path(MirageWeb.Endpoint, :show, slug)
      end

    do_get_link(title, path)
  end

  defp do_get_link(title, path) do
    "[#{title}](#{path})"
  end

  defp map_to_tuple([placeholder, type, note_slug]),
    do: {placeholder, type, note_slug, note_slug}

  defp map_to_tuple([placeholder, type, note_slug, title]),
    do: {placeholder, type, note_slug, title}
end
