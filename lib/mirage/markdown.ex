defmodule Mirage.Markdown do
  @moduledoc """
  Module used for rendering markdown with the correct options
  """

  import Ecto.Changeset, only: [get_change: 2, put_change: 3]

  @markdown_options %Earmark.Options{
    code_class_prefix: "lang- language-",
    footnotes: true,
    breaks: true,
    escape: false
  }

  @doc """
  Renders markdown with Earmark.
  """
  def render(markdown) do
    markdown
    |> clean_escapes()
    |> Mirage.References.replace_references()
    |> Earmark.as_html!(@markdown_options)
  end

  defp clean_escapes(markdown) do
    String.replace(markdown, "\\[", "[", global: true)
  end

  @doc """
  Renders markdown to HTML inside a changeset if markdown changed.
  Markdown field and HTML field can be configured.
  """
  def maybe_render(changeset, markdown_field, html_field) do
    if markdown = get_change(changeset, markdown_field) do
      html = render(markdown)
      put_change(changeset, html_field, html)
    else
      changeset
    end
  end
end
