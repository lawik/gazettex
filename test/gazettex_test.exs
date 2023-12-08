defmodule GazettexTest do
  use ExUnit.Case
  doctest Gazettex

  test "greets the world" do
    assert Gazettex.hello() == :world
  end
end
