defmodule Servy.KickStarter do
  use GenServer

  def start do
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server
    {:ok, server_pid}
  end

  def get_server do
    GenServer.call(__MODULE__, {:call, :get_server})
  end

  def handle_call(:get_server, _from, server_pid) do
    {:reply, server_pid, server_pid}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts("HttpServer exited: #{inspect(reason)}")
    server_pid = start_server
    {:noreply, server_pid}
  end

  defp start_server do
    IO.puts("Starting the HTTP server...")
    port = Application.get_env(:servy, :port)
    server_pid = spawn_link(Servy.HttpServer, :start, [port])
    Process.register(server_pid, :http_server)
    server_pid
  end
end
