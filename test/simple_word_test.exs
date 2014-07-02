defmodule SimpleWordTest do
  use ExUnit.Case, async: true

  alias SandCat.Words

  defmodule TestVoc do
    use SandCat.Core
    defword :square, [a], do: [:dup, :*]
  end

  test "simple words test" do
    assert [18] == SandCat.run([3, :square, 2, :*],
                               [Words.words, TestVoc.words])[:stack]
  end

end