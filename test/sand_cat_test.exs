defmodule SandCatTest do
  use ExUnit.Case

  test "Stack" do
    assert [1] == SandCat.run([1])
    assert [2, 1] == SandCat.run([1, 2])
    assert [3] == SandCat.run([1, 2, :+])
    assert [7] == SandCat.run([1, 2, :+, 4, :+])
  end
end
