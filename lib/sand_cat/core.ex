defmodule SandCat.Core do

  defmacro __using__(_opts) do
    quote do
      import SandCat.Core
      @words []

      @before_compile SandCat.Core
    end
  end

  defmacro defword(expr, effect, opts) do
    do_defword(expr, effect, opts)
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

  defp fun_name(word) do
    word = word |> atom_to_binary
    hash = :crypto.hash(:md5, word) |> :base64.encode
    (hash <> "_word") |> binary_to_atom
  end

  defmacro __before_compile__(_env) do
    quote do
      def words, do: @words
    end
  end

end