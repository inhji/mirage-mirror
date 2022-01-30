defmodule Mirage.MarkdownTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup do
    ExVCR.Config.cassette_library_dir("test/support/cassettes")
    :ok
  end
end
