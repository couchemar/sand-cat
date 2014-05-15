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
      def words, do: @words
    end
  end

  defmacro defword(expr, effect, opts), do: do_defword(expr, effect, opts)

  defmacro defspecial(expr, stack, env, opts) do
    do_defspecial(expr, stack, env, opts)
  end

  defmacro defcombo(expr, effect, opts) do
    do_defcombo(expr, effect, opts)
  end

  defp do_defword(expr, effect, opts) do
    f_name = expr |> fun_name
    args_len = length(effect)
    quote do
      def unquote(f_name)(stack) do
        {args, rest} = Enum.split(
          stack, unquote(Macro.escape(args_len))
        )
        res = (fn(unquote_splicing([effect])) ->
                   unquote(opts[:do])
               end).(args)
        # TODO: probably replace with [a|rest]
        res ++ rest
      end
      @words [{unquote(expr), &(__MODULE__.unquote(f_name)/1)}|@words]
    end
  end

  defp do_defspecial(expr, stack, env, opts) do
    f_name = expr |> fun_name
    quote do
      def unquote(f_name)(s, envi) do
        (fn(unquote(stack), unquote(env)) ->
             unquote(opts[:do])
         end).(s, envi)
      end
      @words [{unquote(expr), &(__MODULE__.unquote(f_name)/2)}|@words]
    end
  end

  alias SandCat, as: SC

  defp do_defcombo(expr, effect, opts) do
    f_name = expr |> fun_name
    args_len = length(effect)
    quote do
      def unquote(f_name)(stack, env) do
        args = Enum.take(
          stack, unquote(Macro.escape(args_len))
        )
        (fn(unquote_splicing([effect])) ->
                   unquote(opts[:do])
         end).(args) |> List.foldl(stack, fn(a,b) -> SC.add_or_apply(env, a, b) end)
      end
      @words [{unquote(expr), &(__MODULE__.unquote(f_name)/2)}|@words]
    end
  end

  defp fun_name(word),
  do: word |> atom_to_binary |> (&(&1 <> "_word")).() |> binary_to_atom

end