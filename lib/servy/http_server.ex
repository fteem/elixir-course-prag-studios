defmodule Servy.HttpServer do
  @doc """
  Starts the server on the given `port` of localhost.
  """
  def start(port) when is_integer(port) and port > 1023 do
    # Creates a socket to listen for client connections. `listen_socket` is
    # bound to the listening socket.
    {:ok, listen_socket} =
      :gen_tcp.listen(port, [:binary, packet: :raw, active: false, reuseaddr: true])

    IO.puts("\n Listening for connection requests on port #{port}...")

    accept_loop(listen_socket)
  end

  @doc """
  Accepts client connections on `listen_socket`.
  """
  def accept_loop(listen_socket) do
    IO.puts("Waiting to accept a client connection...")

    {:ok, client_socket} = :gen_tcp.accept(listen_socket)

    IO.puts("Connection accepted!")

    spawn(fn -> serve(client_socket) end)

    accept_loop(listen_socket)
  end

  @doc """
  Recieves the request on the `client_socket` and sends a response back over
  the same socket.
  """
  def serve(client_socket) do
    client_socket
    |> read_request
    |> Servy.Handler.handle()
    |> write_response(client_socket)
  end

  @doc """
  Receives a request on the `client_socket`.
  """
  def read_request(client_socket) do
    # Read all bytes
    {:ok, request} = :gen_tcp.recv(client_socket, 0)

    IO.puts("Recieved request:")
    IO.puts(request)

    request
  end

  @doc """
  Sends the `response` over the `client_socket`.
  """
  def write_response(response, client_socket) do
    :ok = :gen_tcp.send(client_socket, response)

    IO.puts("Sent response:")
    IO.puts(response)

    :gen_tcp.close(client_socket)
  end
end
