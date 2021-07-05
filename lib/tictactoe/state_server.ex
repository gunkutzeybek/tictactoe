defmodule Game.State.Server do
  use GenServer

  def start_link() do
    GenServer.start_link(Game.State.Server, [], name: StateServer)
  end

  def push(item) do
    GenServer.cast(StateServer, {:push, item})
  end

  def all() do
    GenServer.call(StateServer, :all)
  end

  def delete(item) do
    GenServer.cast(StateServer, {:delete, item})
  end

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    case Enum.member?(state, element) do
      true ->
        state = List.delete(state, element)
        {:noreply, state}
      false ->
        {:noreply, [element | state]}
    end
  end

  @impl true
  def handle_cast({:delete, item}, state) do
    {:noreply, List.delete(state, item)}
  end

  @impl true
  def handle_call(:all, _from, state) do
    {:reply, {:ok, state}, state}
  end
end
