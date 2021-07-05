defmodule TictactoeWeb.Presence do
  @moduledoc """
  Provides presence tracking to channels and processes.

  See the [`Phoenix.Presence`](http://hexdocs.pm/phoenix/Phoenix.Presence.html)
  docs for more details.
  """
  use Phoenix.Presence, otp_app: :tictactoe,
                        pubsub_server: Tictactoe.PubSub

  def fetch(_topic, presences) do
    for {"game:" <> game_id, %{metas: metas}} <- presences, into: %{} do
      {:ok, player_count} = Game.Server.get_player_count(game_id)
      {"game:#{game_id}", %{metas: metas, is_open: player_count == 1}}
    end
  end
end
