defmodule CustomVocabulariesTest do
  use ExUnit.Case, async: true

  alias SandCat.Words

  defmodule MathV do
    use SandCat.Core
    defprimitive :square, [a], do: [a * a]
  end

  test "Custom vocabularies" do
    assert [9] == SandCat.run([3, 3, :*], [Words.words])[:stack]
    assert [9] == SandCat.run([3, :square], [MathV.words])[:stack]
    assert [18] == SandCat.run([3, :square, 2, :*],
                               [Words.words, MathV.words])[:stack]
  end

end