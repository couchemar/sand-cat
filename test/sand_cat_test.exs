defmodule SandCatTest do
  use ExUnit.Case, async: true

  def test_stack(stack), do: SandCat.run(stack)[:stack] |> Enum.reverse

  test "Base stack" do
    assert [1] == test_stack([1])
    assert [1, 2] == test_stack([1, 2])
    assert [3] == test_stack([1, 2, :+])
    assert [7] == test_stack([1, 2, :+, 4, :+])
    assert [6] == test_stack([1, 2, 3, :+, :+])
  end

  test "Arithmetic" do
    assert [15] == test_stack([5, 10, :+])
    assert [25] == test_stack([15, 10, :+])

    assert [1] == test_stack([3, 2, :-])
    assert [-1] == test_stack([2, 3, :-])

    assert [6] == test_stack([3, 2, :*])
    assert [-6] == test_stack([2, -3, :*])

    assert [4] == test_stack([8, 2, :/])
    assert [0.5] == test_stack([4, 8, :/])
  end

  test "Comparing" do
    assert [true] == test_stack([10, 10, :===])
    assert [false] == test_stack([10, 11, :===])

    assert [false] == test_stack([10, 10, :!==])
    assert [true] == test_stack([10, 11, :!==])

    assert [false] == test_stack([10, 10.0, :===])
    assert [true] == test_stack([10.0, 10.0, :===])

    assert [true] == test_stack([10, 10.0, :!==])
    assert [true] == test_stack([10.0, 11.0, :!==])
    assert [false] == test_stack([10.0, 10.0, :!==])

    assert [true] == test_stack([10, 10.0, :==])
    assert [true] == test_stack([10, 11, :!=])

    assert [true] == test_stack([10, 9, :>])
    assert [true] == test_stack([9, 9, :>=])

    assert [true] == test_stack([9, 10, :<])
    assert [true] == test_stack([9, 9, :<=])
  end

  test "Quotation call" do
    assert [3] == test_stack([1, [2, :+], :call])
    assert [6] == test_stack([1, [2, :+], :call, [3, :+], :call])
    assert [12] == test_stack([2, [2, :+, 3, :*], :call])
    assert [9] == test_stack([1, 2, [:+, 3, :*], :call])
    assert [1, 2, 3] == test_stack([1, [2, 3], :call])
  end

  test "Call in calls" do
    assert [3, 3] == test_stack([[3, 3], :call])
    assert [1, 2] == test_stack([[[1], :call, 2], :call])
    assert [1, 2, 3] == test_stack([1, [[2, 3], :call], :call])
    assert [3, 2] == test_stack([[[1, 2, :+], :call, 2], :call])
    assert [42] == test_stack(
        [[[[[[42], :call], :call], :call], :call], :call])
  end

  test "Dup" do
    assert [3, 3] == test_stack([3, :dup])
    assert [4, 4, 4] == test_stack([4, :dup2])
  end

  test "Drop" do
    assert [20] == test_stack([20, 30, :drop])
  end

  test "Swap" do
    assert [2, 1] == test_stack([1, 2, :swap])
  end

  test "Dip" do
    assert [40, 30] == test_stack([20, 2, 30, [:*], :dip])
    assert [10, 30] == test_stack([20, 2, 30, [:/], :dip])
  end

  test "If" do
    assert [true, true] == test_stack([true, [true, true], [false, false], :if])
    assert [false, false] == test_stack([false, [true, true], [false, false], :if])
    assert [7] == test_stack([1, 2, :<, [4, 3, :+], [false, false], :if])
    assert [7] == test_stack([1, 2, :<, [4, 3, :+], [false, false], :if])
  end

  test "When" do
    assert [1] == test_stack([true, [1], :when])
    assert [] == test_stack([false, [1], :when])
  end

end
