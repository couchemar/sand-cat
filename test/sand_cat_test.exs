defmodule SandCatTest do
  use ExUnit.Case, async: true

  test "Base stack" do
    assert [1] == SandCat.run([1])
    assert [2, 1] == SandCat.run([1, 2])
    assert [3] == SandCat.run([1, 2, :+])
    assert [7] == SandCat.run([1, 2, :+, 4, :+])
    assert [6] == SandCat.run([1, 2, 3, :+, :+])
  end

  test "Arithmetic" do
    assert [15] == SandCat.run([5, 10, :+])
    assert [25] == SandCat.run([15, 10, :+])

    assert [1] == SandCat.run([3, 2, :-])
    assert [-1] == SandCat.run([2, 3, :-])

    assert [6] == SandCat.run([3, 2, :*])
    assert [-6] == SandCat.run([2, -3, :*])

    assert [4] == SandCat.run([8, 2, :/])
    assert [0.5] == SandCat.run([4, 8, :/])
  end

  test "Comparing" do
    assert [true] == SandCat.run([10, 10, :===])
    assert [false] == SandCat.run([10, 11, :===])

    assert [false] == SandCat.run([10, 10, :!==])
    assert [true] == SandCat.run([10, 11, :!==])

    assert [false] == SandCat.run([10, 10.0, :===])
    assert [true] == SandCat.run([10.0, 10.0, :===])

    assert [true] == SandCat.run([10, 10.0, :!==])
    assert [true] == SandCat.run([10.0, 11.0, :!==])
    assert [false] == SandCat.run([10.0, 10.0, :!==])

    assert [true] == SandCat.run([10, 10.0, :==])
    assert [true] == SandCat.run([10, 11, :!=])

    assert [true] == SandCat.run([10, 9, :>])
    assert [true] == SandCat.run([9, 9, :>=])

    assert [true] == SandCat.run([9, 10, :<])
    assert [true] == SandCat.run([9, 9, :<=])
  end

  test "Quotation call" do
    assert [3] == SandCat.run([1, [2, :+], :call])
    assert [6] == SandCat.run([1, [2, :+], :call, [3, :+], :call])
    assert [12] == SandCat.run([2, [2, :+, 3, :*], :call])
    assert [9] == SandCat.run([1, 2, [:+, 3, :*], :call])
  end

end
