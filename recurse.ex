defmodule Recurse do
  def triple([head | tail]) do
    [head*3 | triple(tail)]
  end

  def triple([]), do: []

  def my_map([head | tail], f) do
    [f.(head) | my_map(tail, f)]
  end
  def my_map([], _), do: []
end
