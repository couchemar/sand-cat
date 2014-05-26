defmodule SandCat.Words do
  use SandCat.Core

  alias SandCat, as: SC

  defprimitive :+, [a, b], do: [a + b]
  defprimitive :-, [a, b], do: [a - b]
  defprimitive :*, [a, b], do: [a * b]
  defprimitive :/, [a, b], do: [a / b]

  defprimitive :===, [a, b], do: [b === a]
  defprimitive :!==, [a, b], do: [b !== a]
  defprimitive :==, [a, b], do: [b == a]
  defprimitive :!=, [a, b], do: [b != a]

  defprimitive :>, [a, b], do: [a > b]
  defprimitive :>=, [a, b], do: [a >= b]
  defprimitive :<, [a, b], do: [a < b]
  defprimitive :<=, [a, b], do: [a <= b]

  defspecial :call, stack, env do
    [callable|rest] = stack
    callable
    |> List.foldl(rest, fn(val, st) -> SC.add_or_apply(env, val, st) end)
  end

  defprimitive :dup, [a], do: [a, a]
  defword :dup2, [], do: [:dup, :dup]

  defprimitive :drop, [_a], do: []
  defprimitive :swap, [a, b], do: [b, a]
  defword :dip, [item, _quot], do: [:swap, :drop, :call, item]

end