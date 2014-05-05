defmodule SandCat do

  def run(stack) do
    List.foldl(stack, [], &add_or_apply/2)
  end

  defp add_or_apply(value, stack) do
    case is_word(value) do
      false -> [value|stack]
      {true, apply_f} ->
        apply_f.(stack)
    end
  end

  defp is_word(:+), do: {true, &plus/1}
  defp is_word(_), do: false

  defp plus([a|stack]) do
    [b|stack] = stack
    [a + b | stack]
  end

end
