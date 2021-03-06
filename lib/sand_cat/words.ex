defmodule SandCat.Words do
  use SandCat.Core

  alias SandCat.Core

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

  defspecial :call, ctx do
    [callable|rest] = ctx[:stack]
    Core.do_eval(put_in(ctx[:stack], rest), callable)
  end

  defprimitive :dup, [a], do: [a, a]
  defword :dup2, [], do: [:dup, :dup]

  defprimitive :drop, [_a], do: []
  defprimitive :swap, [a, b], do: [b, a]
  defword! :dip, [item, _quot], do: [:swap, :drop, :call, item]

  defprimitive :if, [condition, true_q, false_q] do
    case condition do
      true -> [true_q, :call]
      false -> [false_q, :call]
    end
  end

  defword :when, [], do: [:swap, [:call], [:drop], :if]

  defspecial :stack, ctx do
    [name|rest] = ctx[:stack]
    put_in(ctx[:stack], rest) |> put_in([:stacks, name], [])
  end

  defspecial :"push-stack", ctx do
    [name, val|rest] = ctx[:stack]
    put_in(ctx[:stack], rest)|> update_in([:stacks, name], fn a -> [val|a] end)
  end

  defspecial :"pop-stack", ctx do
    [name|rest] = ctx[:stack]
    [v|stack] = ctx[:stacks][name]
    put_in(ctx[:stack], [v|rest]) |> put_in([:stacks, name], stack)
  end

  defspecial :"init-stack", ctx do
    [name, val|rest] = ctx[:stack]
    put_in(ctx[:stack], rest) |> put_in([:stacks, name], val)
  end

end