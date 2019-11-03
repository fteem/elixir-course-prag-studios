defmodule Servy.Client do
  def run do
    data = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    {:ok, sock} = :gen_tcp.connect('localhost', 4000, [:binary, packet: :raw, active: false])
    :ok = :gen_tcp.send(sock, data)
    {:ok, response} = :gen_tcp.recv(sock, 0) # Read all bytes
    :ok = :gen_tcp.close(sock)
    response
  end
end
