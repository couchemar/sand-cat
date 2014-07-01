defmodule ExistingStackTest do
  use ExUnit.Case, async: true

  alias SandCat.Words

  def new_stack(stack), do: SandCat.new(stack, [Words.words])

  test "pass operation" do
    assert [15] == SandCat.compound(new_stack([5, 10]), [:+])[:stack]
    assert [-1] == SandCat.compound(new_stack([3, 2]), [:-])[:stack]

    assert [0.5] == SandCat.new([], [Words.words])
                    |> SandCat.compound([8])
                    |> SandCat.compound([2])
                    |> SandCat.compound([:/])
                    |> SandCat.compound([8])
                    |> SandCat.compound([:/])
                    |> get_in([:stack])
  end

end