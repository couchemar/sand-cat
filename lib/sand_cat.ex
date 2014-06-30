defmodule SandCat do

  alias SandCat.Words

  @derive [Access]
  defstruct stack: [], vocabularies: []

  def new(stack \\ []), do: struct(__MODULE__, stack: stack)

  def run(stack), do: run(stack, [Words.words])

  def run(stack, vocabularies) do
    compound(struct(__MODULE__, vocabularies: vocabularies), stack)
  end

  def compound(previous, stack), do: do_eval(previous, stack)

  def compound(previous, stack, vocabularies) do
    old_vocab = previous[:vocabularies]
    previous = put_in(previous[:vocabularies], old_vocab ++ vocabularies)
    do_eval(previous, stack)
  end

  defp do_eval(previous, stack) do
    List.foldl(stack, previous, fn(w, ctx) -> add_or_apply(w, ctx) end)
  end

  def add_or_apply(word, ctx) do
    case check_word(ctx, word) do
      {true, apply_f} when is_function(apply_f, 1) ->
        apply_f.(ctx)
      false -> add_to_stack(word, ctx)
    end
  end

  defp check_word(ctx, word) do
    search_word(word, ctx[:vocabularies])
  end

  defp add_to_stack(word, ctx) do
    stack = ctx[:stack]
    put_in(ctx[:stack], [word|stack])
  end

  defp search_word(_word, []), do: false
  defp search_word(word, [{_name, vocab}|vocabs]) do
    case List.keyfind(vocab, word, 0) do
      {^word, f} ->
        {true, f}
      nil -> search_word(word, vocabs)
    end
  end

end
