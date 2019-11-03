defmodule Servy.Parser do
  alias Servy.Conv

  @doc "Parses the incoming request into a conversation map."
  def parse(request) do
    [top, body] = String.split(request, "\r\n\r\n")

    [request_line | header_lines ] = String.split(top, "\r\n")

    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines)

    params = parse_params(headers["Content-Type"], body)

    %Conv{
      method: method,
      path: path,
      params: params,
      headers: headers
    }
  end

  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn(header_line, acc) -> 
      [key, value] = String.split(header_line, ": ")
      Map.put(acc, key, value)
    end)
  end

  @doc """
  Parses the params of of the request in the key=Value&key=Value format, or in
  a JSON format.

  ## Examples
  
    iex> Servy.Parser.parse_params("application/x-www-form-urlencoded", "name=Yogi&type=brown")
    %{"name" => "Yogi", "type" => "brown"}

    iex> Servy.Parser.parse_params("application/json", ~s({ "name": "Yogi", "type": "brown"}))
    %{"name" => "Yogi", "type" => "brown"}

    iex> Servy.Parser.parse_params("multipart/form-data", "name=Yogi&type=brown")
    %{}
  """
  def parse_params("application/x-www-form-urlencoded", params) do
    params |> String.trim |> URI.decode_query
  end
  def parse_params("application/json", params) do
    params
    |> String.trim
    |> Poison.decode!
  end
  def parse_params(_, _), do: %{}
end
