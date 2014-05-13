defmodule SandCat.Words do
  use SandCat.Core

  alias SandCat, as: SC

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

  defspecial :call, stack, env do
    [callable|rest] = stack
    callable
    |> Enum.reverse(rest)
    |> List.foldr([], fn(a,b) -> SC.add_or_apply(env, a, b) end)
  end

end