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
    IO.inspect ctx
    [callable|rest] = ctx[:stack]
    IO.inspect callable
    IO.inspect rest
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

  defspecial :"set-stack", ctx do
    [name|rest] = ctx[:stack]
    ctx = put_in(ctx[:stack], rest)
    stacks = ctx[:stacks]
    put_in(ctx[:stacks], put_in(stacks, [name], []))
  end

  defspecial :"push-stack", ctx do
    [name, val|rest] = ctx[:stack]
    ctx = put_in(ctx[:stack], rest)
    update_in(ctx[:stacks][name], fn a -> [val|a] end)
  end

  defspecial :"pop-stack", ctx do
    [name|rest] = ctx[:stack]
    [v|stack] = ctx[:stacks][name]
    put_in(ctx[:stacks][name], stack)
    |> put_in(ctx[:stack], [v|rest])
  end

end