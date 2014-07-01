defmodule SandCat do

  alias SandCat.Words
  alias SandCat.Core

  @derive [Access]
  defstruct stack: [], vocabularies: []

  def new(stack \\ [], vocabularies \\ []),
  do: struct(__MODULE__, stack: stack, vocabularies: vocabularies)

  def run(stack), do: run(stack, [Words.words])

  def run(stack, vocabularies) do
    compound(struct(__MODULE__, vocabularies: vocabularies), stack)
  end

  def compound(previous, stack), do: Core.do_eval(previous, stack)

  def compound(previous, stack, vocabularies) do
    old_vocab = previous[:vocabularies]
    previous = put_in(previous[:vocabularies], old_vocab ++ vocabularies)
    Core.do_eval(previous, stack)
  end

end
