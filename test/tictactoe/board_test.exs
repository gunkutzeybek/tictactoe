defmodule TicTactoe.BoardTest do
  use ExUnit.Case

  test 'new returns a nine element list' do
    board = TicTactoe.Game.Board.new()
    assert length(board) == 9
  end

  test 'new initializes list with :empty atom' do
    board = TicTactoe.Game.Board.new()
    assert Enum.all?(board, fn x -> x == :empty end)
  end

  test 'put with out of rang 0..8 returns error' do
    assert TicTactoe.Game.Board.put([], -1, :X) == {:error, "Out of range"}
    assert TicTactoe.Game.Board.put([], 9, :x) == {:error, "Out of range"}
  end

  test 'put accepts :x or :o as value' do
    board = TicTactoe.Game.Board.new()
    {:ok, board} = TicTactoe.Game.Board.put(board, 1, :x)
    {:ok, board} = TicTactoe.Game.Board.put(board, 2, :o)
    assert Enum.at(board, 1) == :x
    assert Enum.at(board, 2) == :o
  end

  test 'put does not insert into an already occupied index' do
    board = TicTactoe.Game.Board.new()
    {:ok, board} = TicTactoe.Game.Board.put(board, 1, :x)
    {code, message} = TicTactoe.Game.Board.put(board, 1, :o)
    assert {:error, "Already occupied"} == {code, message}
  end

  test 'full?/0 checks full list' do
    full_board = [:x, :o, :o, :x, :o, :x, :o, :x, :x]
    board_with_one_empty_elm = [:x, :o, :o, :x, :o, :x, :empty, :x, :x]
    assert TicTactoe.Game.Board.full?(full_board)
    refute TicTactoe.Game.Board.full?(board_with_one_empty_elm)
  end
end
