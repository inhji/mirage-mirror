defmodule Mirage.MarkdownTest do
  use Mirage.DataCase

  import Mirage.Markdown, only: [render: 1]

  describe "render" do
    test "render/1 cleans weird escapes from remark before anything else" do
      str = "this is a string with a \\[\\[link]] from markdown"

      assert render(str) =~ "/admin/notes/link"
    end
  end
end
