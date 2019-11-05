defmodule Servy.Bear do
  alias Servy.Bear

  @db_path Path.expand("db", File.cwd!())

  defstruct id: nil, name: "", hibernating: false, type: ""

  def all do
    @db_path
    |> Path.join("bears.json")
    |> read_json
    |> Poison.decode!(as: %{"bears" => [%Bear{}]})
    |> Map.get("bears")
  end

  def get(id) when is_binary(id) do
    id |> String.to_integer() |> get
  end

  def get(id) when is_integer(id) do
    Enum.find(all(), fn b -> b.id == id end)
  end

  def is_grizzly(bear) do
    bear.type == "grizly"
  end

  defp read_json(file_path) do
    case File.read(file_path) do
      {:ok, contents} ->
        contents

      {:error, reason} ->
        IO.inspect("Error reading #{file_path}: #{reason}")
        "[]"
    end
  end
end
