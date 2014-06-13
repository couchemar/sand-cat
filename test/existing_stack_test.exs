defmodule ExistingStackTest do
  use ExUnit.Case, async: true

  test "pass operation" do
    assert [15] == SandCat.compound([5, 10], [:+])
    assert [-1] == SandCat.compound([3, 2], [:-])

    assert [0.5] == [] |> SandCat.compound([8])
                       |> SandCat.compound([2])
                       |> SandCat.compound([:/])
                       |> SandCat.compound([8])
                       |> SandCat.compound([:/])
  end

end