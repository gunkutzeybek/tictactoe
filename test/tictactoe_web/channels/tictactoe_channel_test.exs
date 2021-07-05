defmodule TictactoeWeb.TictactoeChannelTest do
  use TictactoeWeb.ChannelCase

  # setup do
  #   {:ok, _, socket} =
  #     TictactoeWeb.UserSocket
  #     |> socket("user_id", %{some: :assign})
  #     |> subscribe_and_join(TictactoeWeb.TictactoeChannel, "game:5")

  #   %{socket: socket}
  # end

  # test "ping replies with status ok", %{socket: socket} do
  #   ref = push socket, "ping", %{"hello" => "there"}
  #   assert_reply ref, :ok, %{"hello" => "there"}
  # end

  # test "shout broadcasts to game:5", %{socket: socket} do
  #   push socket, "shout", %{"hello" => "all"}
  #   assert_broadcast "shout", %{"hello" => "all"}
  # end

  # test "move bradocasts to game:5", %{socket: socket} do
  #   push socket, "move", %{
  #     "id" => "box1",
  #     "put" => "x"
  #   }
  #   assert_broadcast "move", %{
  #     "id" => "box1",
  #     "put" => "x"
  #   }
  # end

  # test "broadcasts are pushed to the client", %{socket: socket} do
  #   broadcast_from! socket, "broadcast", %{"some" => "data"}
  #   assert_push "broadcast", %{"some" => "data"}
  # end
end
