defmodule AdditionalStacks do
  use ExUnit.Case, async: true

  test "create stack" do
    res = SandCat.run([:test, :stack])
    assert %{test: []} == res[:stacks]
    assert [] == res[:stack]
    assert %{a: [], b: []} == SandCat.run([:a, :stack,
                                           :b, :stack])[:stacks]
  end

  test "push" do
    res = SandCat.run([:test, :stack, 1, 2, 3, :test, :"push-stack"])
    assert %{test: [3]} == res[:stacks]
    assert [2, 1] == res[:stack]
    res = SandCat.compound(res, [:test, :"push-stack"])
    assert %{test: [2, 3]} == res[:stacks]
    assert [1] == res[:stack]
  end

  test "pop" do
    res = SandCat.run([:test, :stack,
                       1, 2, 3,
                       :test, :"push-stack",
                       :test, :"push-stack",
                       :test, :"push-stack"])
    assert %{test: [1, 2, 3]} == res[:stacks]
    assert [] == res[:stack]

    res = SandCat.compound(res, [:test, :"pop-stack"])
    assert %{test: [2, 3]} == res[:stacks]
    assert [1] == res[:stack]
  end

  test "init stack" do
    res = SandCat.run([:test, :stack,
                       [1, 2, 3, :ggg],
                       :test, :"init-stack"])
    assert %{test: [1, 2, 3, :ggg]} == res[:stacks]
    assert [] == res[:stack]
  end

end