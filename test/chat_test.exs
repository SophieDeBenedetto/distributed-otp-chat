defmodule ChatTest do
  use ExUnit.Case, async: true
  @moduletag capture_log: true
  doctest Chat

  # @tag :distributed
  test "send_message" do
    assert Chat.send_message(:moebi@localhost, "hi") == :ok
  end
end
