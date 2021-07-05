defmodule Game.ServerTest do
  use ExUnit.Case

  setup do
    {:ok, spec: %{ id: Game.Server, start: {Game.Server, :start_link, [5]}}}
  end

  test "join/1 returns state containing joined player", meta do
    start_supervised!(meta[:spec])

    assert {:ok, %TicTactoe.Game{players: [:x]}, :x} = Game.Server.join(5)
    assert {:ok, %TicTactoe.Game{players: [:o, :x]}, :o} = Game.Server.join(5)
  end

  test "get_player_count/1 returns player count", meta do
    start_supervised!(meta[:spec])

    assert {:ok, 0} = Game.Server.get_player_count(5)

    Game.Server.join(5)
    assert {:ok, 1} = Game.Server.get_player_count(5)

    Game.Server.join(5)
    assert {:ok, 2} = Game.Server.get_player_count(5)
  end
end
