defmodule SandCat.Words do
  use SandCat.Core

  defword :+, [a, b], do: [a + b]
  defword :-, [a, b], do: [b - a]
  defword :*, [a, b], do: [b * a]
  defword :/, [a, b], do: [b / a]

  defword :===, [a, b], do: [b === a]
  defword :!==, [a, b], do: [b !== a]
  defword :==, [a, b], do: [b == a]
  defword :!=, [a, b], do: [b != a]

  defword :>, [a, b], do: [b > a]
  defword :>=, [a, b], do: [b >= a]
  defword :<, [a, b], do: [b < a]
  defword :<=, [a, b], do: [b <= a]

end