defmodule TictactoeWeb.LobbyChannelTest do
  use TictactoeWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      TictactoeWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(TictactoeWeb.LobbyChannel, "tictactoe:lobby")

    %{socket: socket}
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "init_game replies with status ok and a game_id", %{socket: socket} do
    ref = push socket, "init_game", %{}
    assert_reply ref, :ok, %{game_id: _game_id}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
