defmodule SandCat.Core do

  alias SandCat, as: SC

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

  defmacro defspecial(expr, stack, env, opts) do
    do_defspecial(expr, stack, env, opts)
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
        new_ctx = put_in(ctx[:stack], rest)
        (fn(unquote_splicing([effect |> Enum.reverse])) ->
             unquote(opts[:do])
         end).(args) |> List.foldl(
           new_ctx, fn(val, ctx) -> SC.add_or_apply(val, ctx) end)
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

  defp do_defword(expr, effect, opts) do
    f_name = expr |> fun_name
    args_len = length(effect)
    quote do
      def unquote(f_name)(stack, env) do
        args = Enum.take(
          stack, unquote(Macro.escape(args_len))
        )
        (fn(unquote_splicing([effect |> Enum.reverse])) ->
                   unquote(opts[:do])
         end).(args) |> List.foldl(stack, fn(a,b) -> SC.add_or_apply(env, a, b) end)
      end
      @words [{unquote(expr), &(__MODULE__.unquote(f_name)/2)}|@words]
    end
  end

  defp fun_name(word),
  do: word |> Atom.to_string |> (&(&1 <> "_word")).() |> String.to_atom

end