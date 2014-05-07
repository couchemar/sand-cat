defmodule SandCat.Core do

  defmacro __using__(_opts) do
    quote do
      import SandCat.Core
      @words []
    end
  end

  defmacro defword(expr, effect, opts) do
    do_defword(expr, effect, opts)
  end

  defp do_defword(expr, effect, opts) do
    f_name = expr |> fun_name
    quote do
      def unquote(f_name)(unquote_splicing([effect])) do
        unquote(opts[:do])
      end
      @words [{unquote(expr), &(__MODULE__.unquote(f_name)/1)}|@words]
    end
  end

  defp fun_name(word) do
    word = word |> atom_to_binary
    hash = :crypto.hash(:md5, word) |> :base64.encode
    (hash <> "_word") |> binary_to_atom
  end

end