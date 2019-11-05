defmodule Servy.FourOhFourCounter do
  @name :four_oh_four_counter

  use GenServer

  def start_link(_arg) do
    GenServer.start(__MODULE__, %{}, name: @name)
  end

  def reset, do: GenServe.cast(@name, :reset)
  def bump_count(path), do: GenServer.cast(@name, {:bump, path})
  def get_count(path), do: GenServer.call(@name, {:count, path})
  def get_counts, do: GenServer.call(@name, :counts)

  def handle_cast(:reset, _state), do: {:noreply, %{}}

  def handle_cast({:bump, path}, state) do
    count = Map.get(state, path, 0)
    new_state = Map.put(state, path, count + 1)
    {:noreply, new_state}
  end

  def handle_call({:count, path}, _from, state) do
    count = Map.get(state, path, 0)
    new_state = Map.put(state, path, count + 1)
    {:reply, count, new_state}
  end

  def handle_call(:counts, _from, state), do: {:reply, state, state}
end
