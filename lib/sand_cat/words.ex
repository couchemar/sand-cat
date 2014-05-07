defmodule SandCat.Words do
  use SandCat.Core

  defword :+, [a, b | stack] do
    [a + b | stack]
  end

end