defmodule ExistingStackTest do
  use ExUnit.Case, async: true

  test "pass operation" do
    assert [15] == SandCat.compound(SandCat.new([5, 10]), [:+])[:stack]
    assert [-1] == SandCat.compound(SandCat.new([3, 2]), [:-])[:stack]

    assert [0.5] == SandCat.new |> SandCat.compound([8])
                                |> SandCat.compound([2])
                                |> SandCat.compound([:/])
                                |> SandCat.compound([8])
                                |> SandCat.compound([:/])
                                |> get_in([:stack])
  end

end