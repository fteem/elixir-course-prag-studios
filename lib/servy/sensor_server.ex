defmodule Servy.SensorServer do
  @name :sensor_server

  use GenServer

  defmodule State do
    defstruct sensor_data: %{}, refresh_interval: :timer.seconds(5)
  end

  def start do
    GenServer.start(__MODULE__, %State{}, name: @name)
  end

  def get_sensor_data do
    GenServer.call @name, :get_sensor_data
  end

  def set_refresh_interval(interval) do
    GenServer.cast @name, {:set_interval, interval}
  end

  # Server Callbacks

  def init(state) do
    sensor_data = run_tasks_to_get_sensor_data()
    schedule_refresh(state.refresh_interval)
    {:ok, %{ state | sensor_data: sensor_data }}
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:set_interval, interval}, state) do
    schedule_refresh(interval)
    {:noreply, %{ state | refresh_interval: interval }}
  end

  def handle_info(:refresh, state) do
    IO.puts "Refreshing the cache..."
    new_data = run_tasks_to_get_sensor_data()
    schedule_refresh(state.refresh_interval)
    {:noreply, %{ state | sensor_data: new_data }}
  end

  defp schedule_refresh(interval) do
    Process.send_after(self(), :refresh, interval)
  end

  defp run_tasks_to_get_sensor_data do
    task = Task.async(fn -> Servy.Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> Servy.VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await/1)

    bigfoot_location = Task.await(task)

    %{ snapshots: snapshots, location: bigfoot_location }
  end
end
