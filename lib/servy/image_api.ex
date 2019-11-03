defmodule Servy.ImageApi do
  def query(id) do
    do_request(id)
    |> extract
    |> decode
    |> handle
  end

  defp do_request(id) do
    HTTPoison.get "https://api.myjson.com/bins/#{id}"
  end

  defp extract({:ok, %HTTPoison.Response{status_code: 200, body: body}}), do: { :ok, body }
  defp extract({:ok, %HTTPoison.Response{status_code: status, body: body}}), do: { :response_error, body }
  defp extract({:error, %HTTPoison.Error{id: nil, reason: reason}}), do: { :error, reason }

  defp decode({ :ok, body }), do: { :ok, Poison.decode!(body) }
  defp decode({ :response_error, body }), do: { :response_error, Poison.decode!(body) }
  defp decode({ :error, reason }), do: { :error, reason }

  defp handle({ :ok, %{ "image" => %{ "image_url" => url } } }), do: { :ok, url }
  defp handle({ :response_error, %{ "message" => message }}), do: { :error, message }
  defp handle({ :error, reason }), do: { :error, reason }
end
