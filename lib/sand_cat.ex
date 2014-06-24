defmodule SandCat do

  alias SandCat.Words

  @derive [Access]
  defstruct stack: [], vocabularies: []

  def new(stack \\ []), do: struct(__MODULE__, stack: stack)

  def run(stack) do
    run(stack, Words.words)
  end

  def run(stack, vocabulary) do
    compound(struct(__MODULE__), stack, vocabulary)
  end

  def compound(previous, stack) do
    compound(previous, stack, Words.words)
  end

  def compound(previous, stack, vocabulary) do
    new_stack =  List.foldl(stack, previous[:stack], fn(a,b) -> add_or_apply(vocabulary, a, b) end)
    put_in(previous[:stack], new_stack)
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
