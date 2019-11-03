defmodule HttpServerTest do
  use ExUnit.Case

  alias Servy.HttpServer
  alias Servy.HttpClient

  test "accepts a request on a socket and sends back a response" do
    spawn(HttpServer, :start, [4000])

    [
      "http://localhost:4000/wildthings",
      "http://localhost:4000/wildthings",
      "http://localhost:4000/wildthings",
      "http://localhost:4000/wildthings",
      "http://localhost:4000/wildthings"
    ]
    |> Enum.map(fn(url) -> Task.async(fn -> HTTPoison.get(url) end) end)
    |> Enum.map(&Task.await/1)
    |> Enum.map(fn ({:ok, response}) -> assert response.status_code == 200 end)
  end
end
