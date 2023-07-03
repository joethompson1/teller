defmodule TellerApiTest do
  use ExUnit.Case
  doctest TellerApi

  test "greets the world" do
    assert TellerApi.hello() == :world
  end
end
