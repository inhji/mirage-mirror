defmodule Mirage.Markdown do
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
  def render(markdown, opts \\ [admin: false]) do
    markdown
    |> Mirage.References.replace_references(opts)
    |> Earmark.as_html!(@markdown_options)
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
