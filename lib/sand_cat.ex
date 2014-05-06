defmodule SandCat do

  alias SandCat.Words

  def run(stack) do
    List.foldl(stack, [], fn(a,b) -> add_or_apply(Words.words, a, b) end)
  end

  defp add_or_apply(env, value, stack) do
    case is_word(env, value) do
      false -> [value|stack]
      {true, apply_f} ->
        apply_f.(stack)
    end
  end

  defp is_word(env, word) do
    case env |> List.keyfind(word, 0) do
      {^word, f} -> {true, f}
      nil -> false
    end
  end

end
