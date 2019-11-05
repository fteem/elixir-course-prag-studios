defmodule Servy.PledgeServer do
  @name :pledge_server

  use GenServer

  defmodule State do
    defstruct cache_size: 3, pledges: []
  end

  def start_link(_arg) do
    GenServer.start_link(__MODULE__, %State{}, name: @name)
  end

  def set_cache_size(size), do: GenServer.cast(@name, {:set_cache_size, size})
  def create_pledge(name, amount), do: GenServer.call(@name, {:create_pledge, name, amount})
  def recent_pledges, do: GenServer.call(@name, :recent_pledges)
  def total_pledged, do: GenServer.call(@name, :total_pledged)
  def clear, do: GenServer.cast(@name, :clear)

  def init(state) do
    pledges = fetch_recent_pledges_from_service()
    {:ok, %{state | pledges: pledges}}
  end

  def handle_call(:total_pledged, _from, state) do
    total = state.pledges |> Enum.map(&elem(&1, 1)) |> Enum.sum()
    {:reply, total, state}
  end

  def handle_call(:recent_pledges, _from, state), do: {:reply, state.pledges, state}

  def handle_call({:create_pledge, name, amount}, _from, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state.pledges, state.cache_size - 1)
    cached_pledges = [{name, amount} | most_recent_pledges]
    new_state = %{state | pledges: cached_pledges}
    {:reply, id, new_state}
  end

  def handle_info(message, state) do
    IO.puts("Can't touch this! #{inspect(message)}")
    {:noreply, state}
  end

  def handle_cast(:clear, state) do
    {:noreply, %{state | pledges: []}}
  end

  def handle_cast({:set_cache_size, size}, state) do
    most_recent_pledges = Enum.take(state.pledges, size)
    {:noreply, %{state | cache_size: size, pledges: most_recent_pledges}}
  end

  defp send_pledge_to_service(name, amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

  defp fetch_recent_pledges_from_service do
    [{"wilma", 15}, {"fred", 25}]
  end
end

alias Servy.PledgeServer

{:ok, pid} = PledgeServer.start()
IO.inspect(PledgeServer.recent_pledges())

PledgeServer.set_cache_size(4)

IO.inspect(PledgeServer.create_pledge("Larry", 30))
IO.inspect(PledgeServer.create_pledge("Jane", 10))
IO.inspect(PledgeServer.create_pledge("John", 33))
IO.inspect(PledgeServer.create_pledge("Bill", 20))
IO.inspect(PledgeServer.create_pledge("Ellie", 50))
PledgeServer.set_cache_size(2)

IO.inspect(PledgeServer.recent_pledges())
