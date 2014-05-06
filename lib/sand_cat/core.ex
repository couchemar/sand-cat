defmodule SandCat.Core do

  defmacro __using__(opts) do
    Module.register_attribute __CALLER__.module, :words,
                              accumulate: true,
                              persist: false
    quote do
      import SandCat.Core
    end
  end

  defmacro defword(expr, effect, opts) do
    do_defword(expr, effect, opts)
  end

  defp do_defword(expr, effect, opts) do
    quote do
      def plus(unquote_splicing([effect])) do
        unquote(opts[:do])
      end
    end
  end

end