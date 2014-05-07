defmodule SandCat.Words do
  use SandCat.Core

  defword :+, [a, b] do
   [a + b]
  end

end