defmodule Mirage.Helper do
  def random_string() do
    for _ <- 1..10, into: "", do: <<Enum.random('0123456789abcdef')>>
  end
end
