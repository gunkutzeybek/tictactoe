defmodule TicTactoe.GameTest do
  use ExUnit.Case

  test "generate_unique_game_id returns id" do
    game_id = TicTactoe.Game.generate_unique_game_id()
    assert(game_id, "game_id is not truthy!")
  end

  test "new with default parameter returns game with turn :x" do
    %{turn: turn} = TicTactoe.Game.new()
    assert(turn == :x)
  end

  test "new with :o parameter returns game turn :o" do
    %{turn: turn} = TicTactoe.Game.new(:o)
    assert(turn == :o)
  end

  describe "join/1" do
    test "join a game having two players does not allow joining" do
      game = %TicTactoe.Game{players: [:x, :o]}
      {status, _reason} = TicTactoe.Game.join(game)
      assert status == :error
    end

    test "join a game having only :x player adds player as :o" do
      game = %TicTactoe.Game{players: [:x]}
      {:ok, %TicTactoe.Game{players: players}, player} = TicTactoe.Game.join(game)
      assert Enum.member?(players, :o)
      assert player == :o
    end
  end

  describe "is_open/1" do
    test "returns error when game is full" do
      game = %TicTactoe.Game{players: [:x, :o]}
      {:error, reason} = TicTactoe.Game.is_open(game)
      assert reason == "Game is full"
    end

    test "return :ok result when game has one active players" do
      game = %TicTactoe.Game{players: [:x]}
      {status, _game} = TicTactoe.Game.is_open(game)
      assert status == :ok
    end
  end

  describe "make_move/3" do
    test "returns Game over if game is over" do
      game = %TicTactoe.Game{over: true}
      {status, reason} = TicTactoe.Game.make_move(game, :x, 1)
      assert status == :error
      assert reason == "Game over"
    end

    test "returns error, not your turn if it is not the players turn" do
      game = %TicTactoe.Game{turn: :x}
      player = :o
      {status,reason} = TicTactoe.Game.make_move(game, player, 2)
      assert status == :error
      assert reason == "Not your turn"
    end

    test "returns game with other players turn" do
      game = %TicTactoe.Game{board: [:x, :empty,:empty,:empty,:empty,:empty,:empty,:empty,:empty], turn: :o}
      {status, %TicTactoe.Game{turn: turn}} = TicTactoe.Game.make_move(game, :o, 1)
      assert status == :ok
      assert turn == :x
    end

    test "updates board with given move" do
      game = %TicTactoe.Game{board: [:x, :empty,:empty,:empty,:empty,:empty,:empty,:empty,:empty], turn: :o}
      {status, %TicTactoe.Game{board: board}} = TicTactoe.Game.make_move(game, :o, 1)
      assert status == :ok
      assert Enum.at(board, 1) == :o
    end

    test "determines winner and marks game over" do
      game = %TicTactoe.Game{board: [:x, :x, :empty,:empty,:empty,:empty,:empty,:empty,:empty], turn: :x}
      {status, %TicTactoe.Game{winner: winner, over: over}} = TicTactoe.Game.make_move(game, :x, 2)
      assert status == :ok
      assert winner == :x
      assert over == true
    end

    test "determines winner [0,3,6]" do
      game = %TicTactoe.Game{board: [:x, :x, :empty,:x,:empty,:empty,:empty,:empty,:empty], turn: :x}
      {status, %TicTactoe.Game{winner: winner}} = TicTactoe.Game.make_move(game, :x, 6)
      assert status == :ok
      assert winner == :x
    end

    test "determines winner [2,5,8]" do
      game = %TicTactoe.Game{board: [:o, :empty, :x,:o,:empty,:x,:empty,:empty,:empty], turn: :x}
      {status, %TicTactoe.Game{winner: winner}} = TicTactoe.Game.make_move(game, :x, 8)
      assert status == :ok
      assert winner == :x
    end

    test "determines winner [1,4,7]" do
      game = %TicTactoe.Game{board: [:o, :x, :empty,:x,:empty,:empty,:empty,:x,:empty], turn: :x}
      {status, %TicTactoe.Game{winner: winner}} = TicTactoe.Game.make_move(game, :x, 4)
      assert status == :ok
      assert winner == :x
    end

    test "determines winner [3,4,5]" do
      game = %TicTactoe.Game{board: [:o, :o, :empty,:x,:x,:empty,:empty,:o,:empty], turn: :x}
      {status, %TicTactoe.Game{winner: winner}} = TicTactoe.Game.make_move(game, :x, 5)
      assert status == :ok
      assert winner == :x
    end

    test "determines winner [6,7,8]" do
      game = %TicTactoe.Game{board: [:o, :o, :empty,:empty,:o,:empty,:empty,:x,:x], turn: :x}
      {status, %TicTactoe.Game{winner: winner}} = TicTactoe.Game.make_move(game, :x, 6)
      assert status == :ok
      assert winner == :x
    end

    test "determines winner [0, 4, 8]" do
      game = %TicTactoe.Game{board: [:x, :o, :empty,:empty,:empty,:o,:empty,:x,:x], turn: :x}
      {status, %TicTactoe.Game{winner: winner}} = TicTactoe.Game.make_move(game, :x, 4)
      assert status == :ok
      assert winner == :x
    end

    test "determines winner [2, 4, 6]" do
      game = %TicTactoe.Game{board: [:empty, :o, :x,:empty,:x,:o,:empty,:empty,:empty], turn: :x}
      {status, %TicTactoe.Game{winner: winner}} = TicTactoe.Game.make_move(game, :x, 6)
      assert status == :ok
      assert winner == :x
    end

    test "determines a draw" do
      game = %TicTactoe.Game{board: [:x, :o, :x,:o,:x,:o,:o,:empty,:o], turn: :x}
      {status, %TicTactoe.Game{winner: winner}} = TicTactoe.Game.make_move(game, :x, 7)
      assert status == :ok
      assert winner == :draw
    end

    test "returns error with an invalid move" do
      game = %TicTactoe.Game{board: [:x, :o, :x,:o,:x,:o,:o,:empty,:o], turn: :x}
      {status, _reason} = TicTactoe.Game.make_move(game, :x, 9)
      assert status == :error
    end
  end

  describe "opposit_player/1" do
    test "returns :o for :x" do
      opposite = TicTactoe.Game.opposite_player(:x)
      assert opposite == :o
    end

    test "returns :x for :o" do
      opposite = TicTactoe.Game.opposite_player(:o)
      assert opposite == :x
    end
  end
end
