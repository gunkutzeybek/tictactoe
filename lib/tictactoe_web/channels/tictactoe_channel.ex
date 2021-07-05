defmodule TictactoeWeb.TictactoeChannel do
  use TictactoeWeb, :channel

  alias TictactoeWeb.{GameView}

  @impl true
  def join("game:" <> game_id, _payload, socket) do
    case Game.Server.join(game_id) do
      {:ok, game, player} ->
        send(self(), {:after_join, game_id})

        socket = assign(socket, :game_id, to_string(game_id))
        socket = assign(socket, :player, player)

        {:ok, %{player: GameView.present_player(player), game: GameView.game_json(game)}, socket}

      {:error, reason} ->
        {:error, reason}
    end
  end

  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("make_move", %{"player" => player, "position" => position}, socket) do
    case Game.Server.make_move(socket.assigns.game_id, player_string_to_atom(player), position) do
      {:ok, game} ->
        game_json = Phoenix.View.render(GameView, "game.json", Map.from_struct(game))
        broadcast!(socket, "make_move", game_json)
        {:reply, {:ok, game_json}, socket}

      {:error, reason} ->
        {:reply, {:error, reason}, socket}
    end
  end

  @impl true
  def handle_info({:after_join, _player}, socket) do
    Game.State.Server.push(socket.assigns.game_id)

    game = Game.Server.get_state(socket.assigns.game_id)
    if length(game.players) == 2, do: broadcast(socket, "start_game", %{})

    #{:ok, _} = Presence.track(socket, "player:#{player}", %{})

    #push(socket, "presence_state", Presence.list(socket))

    {:noreply, socket}
  end

  defp player_string_to_atom(str) when is_binary(str) do
    case str do
      "X" -> :x
      "O" -> :o
      _ -> nil
    end
  end
end
