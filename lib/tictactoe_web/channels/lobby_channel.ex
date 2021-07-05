defmodule TictactoeWeb.LobbyChannel do
  use TictactoeWeb, :channel

  @impl true
  def join("tictactoe:lobby", _payload, socket) do
    send(self(), :after_join)
    {:ok, %{}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  @impl true
  def handle_in("init_game", _payload, socket) do
    game_id = TicTactoe.Game.generate_unique_game_id()
    {:ok, _state} = Game.Supervisor.start_game(game_id)
    {:reply, {:ok, %{game_id: game_id}}, socket}
  end

  @impl true
  def handle_in("presence_update", _payload, socket) do
    {:ok, state} = Game.State.Server.all()

    broadcast socket, "presence_state", %{game_ids: state}
    {:noreply, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    {:ok, state} = Game.State.Server.all()

    push socket, "presence_state", %{game_ids: state}
    {:noreply, socket}
  end
end
