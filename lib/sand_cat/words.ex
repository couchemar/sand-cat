defmodule SandCat.Words do
  use SandCat.Core

  defword :+, [a, b | stack] do
    [a + b | stack]
  end

  def words, do: [+: &plus/1]

end