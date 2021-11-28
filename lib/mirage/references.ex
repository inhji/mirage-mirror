defmodule Mirage.References do
  @hashid_reference_regex ~r/\[\[(?<id>[\d\w-]+)(?:\|(?<title>[\w\d\s']+))?\]\]/

  def get_references(string) do
    @hashid_reference_regex
    |> Regex.scan(string, capture: :all)
    |> Enum.map(&map_to_tuple/1)
  end

  def replace_references(string, opts \\ [admin: false]) do
    path =
      if opts[:admin] do
        "/admin/notes"
      else
        "/notes"
      end

    string
    |> get_references()
    |> Enum.reduce(string, fn {placeholder, slug, title}, s ->
      String.replace(s, placeholder, get_link(slug, title, path))
    end)
  end

  defp get_link(slug, title, path), do: "[#{title}](#{path}/#{slug})"

  defp map_to_tuple([placeholder, note_slug]), do: {placeholder, note_slug, note_slug}
  defp map_to_tuple([placeholder, note_slug, title]), do: {placeholder, note_slug, title}
end
