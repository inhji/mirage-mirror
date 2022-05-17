defmodule Mirage.References do
  @moduledoc """
  Finds and replaces references to entities in a string.

  A reference is an internal link like the following examples:

  * `[[sustainablity]]` -> A note named *Sustainability*
  * `[[tag:video-games]]` -> A tag named *Video Games*
  * `[[list:blog]]` -> A list named *Blog*
  * `[[a-long-unfitting-title|A simple title]]` -> A note named *A long unfitting title*
  """

  alias MirageWeb.Router.Helpers, as: Routes

  @hashid_reference_regex ~r/\[\[(?:(?<type>list|tag):)?(?<id>[\d\w-]+)(?:\|(?<title>[\w\d\s']+))?\]\]/

  @doc """
  Returns a list of references in `string`.
  """
  def get_references(nil), do: []

  def get_references(string) do
    @hashid_reference_regex
    |> Regex.scan(string, capture: :all)
    |> Enum.map(&map_to_tuple/1)
  end

  @doc """
  Returns a list of slugs that are referenced in `string`, optionally filtering by `filter_type`.
  """
  def get_reference_ids(string, filter_type \\ "note") do
    string
    |> get_references()
    |> Enum.filter(fn {_, type, _, _} = _ref -> type == filter_type end)
    |> Enum.map(fn {_, _, note_slug, _} = _ref -> note_slug end)
  end

  @doc """
  Finds and replaces references with the matching url in `string`.
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
          Routes.tag_path(MirageWeb.Endpoint, :show, slug)

        "list" ->
          Routes.list_path(MirageWeb.Endpoint, :show, slug)

        _ ->
          Routes.note_path(MirageWeb.Endpoint, :show, slug)
      end

    do_get_link(title, path)
  end

  defp do_get_link(title, path) do
    "[#{title}](#{path})"
  end

  defp map_to_tuple([placeholder, type, note_slug]),
    do: {placeholder, get_reference_type(type), note_slug, note_slug}

  defp map_to_tuple([placeholder, type, note_slug, title]),
    do: {placeholder, get_reference_type(type), note_slug, title}

  defp get_reference_type(nil), do: "note"
  defp get_reference_type(""), do: "note"
  defp get_reference_type(type), do: type
end
