defmodule Servy.GenericServerOrig do
  def start(callback_module, state, name) do
    pid = spawn(__MODULE__, :listen_loop, [state, callback_module])
    Process.register(pid, name)
    pid
  end

  def call(pid, message)  do
    send pid, {:call, self(), message}

    receive do {:response, response} -> response end
  end

  def cast(pid, message), do: send pid, {:cast, message}

  def listen_loop(state, callback_module) do
    IO.puts "\nWaiting for a message..."

    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state, callback_module)
      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)
        listen_loop(new_state, callback_module)
      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        callback_module.handle_info(unexpected, state)
        listen_loop(state, callback_module)
    end
  end
end

defmodule Servy.PledgeServerOrig do
  @name :pledge_server

  alias Servy.GenericServerOrig

  def start(state \\ []), do: GenericServer.start(__MODULE__, [], @name)

  def create_pledge(name, amount), do: GenericServer.call @name, {:create_pledge, name, amount}
  def recent_pledges, do: GenericServer.call @name, :recent_pledges
  def total_pledged, do: GenericServer.call @name, :total_pledged
  def clear, do: GenericServer.cast @name, :clear

  def handle_call(:total_pledged, state) do
    total = state |> Enum.map(&elem(&1, 1)) |> Enum.sum
    {total, state}
  end
  def handle_call(:recent_pledges, state), do: {state, state}
  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [ {name, amount} | most_recent_pledges ]
    {id, new_state}
  end

  def handle_cast(:clear, state), do: []
  def handle_info(message, state) do
    IO.puts "Unexpected message: #{inspect message}"
    state
  end

  defp send_pledge_to_service(name, amount) do
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
