defmodule SandCat.Words do

  def plus([a, b|stack]) do
    [a + b | stack]
  end

  def words, do: [+: &plus/1]

end