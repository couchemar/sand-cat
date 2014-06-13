defmodule SandCat do

  alias SandCat.Words

  def run(stack) do
    run(stack, Words.words)
  end

  def run(stack, vocabulary) do
    compound([], stack, vocabulary)
    |> Enum.reverse
  end

  def compound(previous, stack) do
    compound(previous, stack, Words.words)
  end

  def compound(previous, stack, vocabulary) do
    List.foldl(stack, previous, fn(a,b) -> add_or_apply(vocabulary, a, b) end)
  end

  def add_or_apply(env, value, stack) do
    case check_word(env, value) do
      {true, apply_f} when is_function(apply_f, 2) ->
        apply_f.(stack, env)
      false -> [value|stack]
    end
  end

  defp check_word(env, word) do
    case env |> List.keyfind(word, 0) do
      {^word, f} -> {true, f}
      nil -> false
    end
  end

end
