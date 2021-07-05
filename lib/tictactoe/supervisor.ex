defmodule Game.Supervisor do
  use DynamicSupervisor

  def start_link(_args) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def start_game(id) do
    spec = %{
      id: Game.Server,
      start: {Game.Server, :start_link, [id]}
    }

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  def start_state_server() do
    spec = %{
      id: Game.State.Server,
      start: {Game.State.Server, :start_link, []}
    }

    DynamicSupervisor.start_child(__MODULE__, spec)
  end

  @impl true
  def init(_args) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
