defmodule TicTactoe.Game.Board do
  def new(), do: List.duplicate(:empty, 9)

  def put(_board, position, _value) when position not in 0..8, do: {:error, "Out of range"}

  def put(_board, _position, value) when value not in [:x, :o],
    do: {:error, "Invalid value. Must be :x or :o"}

  def put(board, position, value) do
    case Enum.at(board, position) do
      :empty ->
        {:ok, List.replace_at(board, position, value)}

      _ ->
        {:error, "Already occupied"}
    end
  end

  def full?(board), do: Enum.all?(board, &(&1 !== :empty))
end
