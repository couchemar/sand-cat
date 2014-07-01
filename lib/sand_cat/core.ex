defmodule SandCat.Core do

  defmacro __using__(_opts) do
    quote do
      import SandCat.Core
      @words []

      @before_compile SandCat.Core
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def words, do: {__MODULE__, @words}
    end
  end

  defmacro defprimitive(expr, effect, opts) do
    do_defprimitive(expr, effect, opts)
  end

  defmacro defspecial(expr, ctx, opts) do
    do_defspecial(expr, ctx, opts)
  end

  defmacro defword(expr, effect, opts) do
    do_defword(expr, effect, opts)
  end

  defp do_defprimitive(expr, effect, opts) do
    f_name = expr |> fun_name
    args_len = length(effect)
    quote do
      def unquote(f_name)(ctx) do
        {args, rest} = Enum.split(
          ctx[:stack], unquote(Macro.escape(args_len))
        )
        do_eval(
                put_in(ctx[:stack], rest),
                (fn(unquote_splicing([effect |> Enum.reverse])) ->
                     unquote(opts[:do])
                 end).(args)
        )
      end
      @words [{unquote(expr), &(__MODULE__.unquote(f_name)/1)}|@words]
    end
  end

  defp do_defspecial(expr, ctx, opts) do
    f_name = expr |> fun_name
    quote do
      def unquote(f_name)(ctx_o) do
        (fn(unquote(ctx)) ->
             unquote(opts[:do])
         end).(ctx_o)
      end
      @words [{unquote(expr), &(__MODULE__.unquote(f_name)/1)}|@words]
    end
  end

  defp do_defword(expr, effect, opts) do
    f_name = expr |> fun_name
    args_len = length(effect)
    quote do
      def unquote(f_name)(ctx) do
        args = Enum.take(
          ctx[:stack], unquote(Macro.escape(args_len))
        )
        do_eval(
                ctx,
                (fn(unquote_splicing([effect |> Enum.reverse])) ->
                     unquote(opts[:do])
                 end).(args)
        )
      end
      @words [{unquote(expr), &(__MODULE__.unquote(f_name)/1)}|@words]
    end
  end

  defp fun_name(word),
  do: word |> Atom.to_string |> (&(&1 <> "_word")).() |> String.to_atom

  def do_eval(previous, stack) do
    List.foldl(stack, previous, fn(w, ctx) -> add_or_apply(w, ctx) end)
  end

  defp add_or_apply(word, ctx) do
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