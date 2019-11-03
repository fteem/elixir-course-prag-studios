defmodule Servy.Handler do
  import Servy.Plugins, only: [rewrite: 1, log: 1, emojify: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [handle_file: 2]
  import Servy.MarkdownHandler, only: [handle_md: 2]

  alias Servy.Conv
  alias Servy.BearController
  alias Servy.VideoCam
  alias Servy.FourOhFourCounter, as: Counter

  @moduledoc "Handles HTTP requests."

  @pages_path Path.expand("pages", File.cwd!)

  @doc "Transforms the request in a response."
  def handle(request) do
    request
    |> parse
    |> rewrite
    |> log
    |> route
    |> emojify
    |> track
    |> put_content_length
    |> format_response
  end

  def route(%Conv{ method: "GET", path: "/pledges" } = conv) do
    Servy.PledgeController.index(conv)
  end

  def route(%Conv{ method: "GET", path: "/pledges/new" } = conv) do
    Servy.PledgeController.new(conv)
  end

  def route(%Conv{ method: "POST", path: "/pledges" } = conv) do
    Servy.PledgeController.create(conv, conv.params)
  end

  def route(%Conv{ method: "GET", path: "/sensors" } = conv) do
    sensor_data = Servy.SensorServer.get_sensor_data()

    %{ conv | status: 200, resp_body: inspect(sensor_data) }
  end

  def route(%Conv{ method: "GET", path: "/wildthings" } = conv) do
    %Conv{ conv | resp_body: "Bears, Lions, Tigers, Girraffes", status: 200 }
  end

  def route(%Conv{ method: "GET", path: "/api/bears" } = conv) do
    Servy.API.BearController.index(conv)
  end

  def route(%Conv{ method: "POST", path: "/api/bears" } = conv) do
    Servy.API.BearController.create(conv, conv.params)
  end

  def route(%Conv{ method: "GET", path: "/bears" } = conv) do
    BearController.index(conv)
  end

  def route(%Conv{ method: "GET", path: "/bears/new" } = conv) do
    @pages_path
    |> Path.join("form.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{ method: "GET", path: "/bears/" <> id } = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.show(conv, params)
  end

  def route(%Conv{ method: "DELETE", path: "/bears/" <> id } = conv) do
    params = Map.put(conv.params, "id", id)
    BearController.delete(conv, params)
  end

  def route(%Conv{ method: "GET", path: "/pages/faq" } = conv) do
    @pages_path
    |> Path.join("faq.md")
    |> File.read
    |> handle_md(conv)
  end

  def route(%Conv{ method: "GET", path: "/pages/" <> page } = conv) do
    @pages_path
    |> Path.join("#{page}.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{ method: "POST", path: "/bears" } = conv) do
    %Conv{ conv | resp_body: "Create a bear with name #{conv.params["name"]} and type #{conv.params["type"]}", status: 201 }
  end

  def route(%Conv{ method: "GET", path: "/about" } = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{ method: "GET", path: "/404s" } = conv) do
    %Conv{ conv | status: 200, resp_body: "#{inspect Counter.get_counts()}" }
  end

  def route(%Conv{ path: path } = conv) do
    %Conv{ conv | resp_body: "No #{path} here!", status: 404 }
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    #{format_response_headers(conv)}
    \r
    #{conv.resp_body}
    """
  end

  def format_response_headers(conv) do
    conv.resp_headers
    |> Enum.map(fn({k, v}) -> "#{k}: #{v}\r" end)
    |> Enum.sort
    |> Enum.reverse
    |> Enum.join("\n")
  end

  def put_content_length(conv) do
    %{ conv | resp_headers: %{ conv.resp_headers | "Content-Length" => byte_size(conv.resp_body) } }
  end
end
