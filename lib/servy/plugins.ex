defmodule Servy.Plugins do
  alias Servy.Conv
  alias Servy.FourOhFourCounter, as: Counter

  def log(%Conv{} = conv) do
    if Mix.env == :dev do
      IO.inspect conv
    end
    conv
  end

  def emojify(%Conv{status: 200, resp_body: resp_body } = conv) do
    %{ conv | resp_body: "👌 #{resp_body} 👌" }
  end
  def emojify(%Conv{} = conv), do: conv

  def track(%Conv{ status: 404, path: path } = conv) do
    if Mix.env != :test do
      IO.puts "Warning: #{path} is on the loose!"
    end
    Counter.bump_count(path)
    conv
  end
  def track(%Conv{} = conv), do: conv

  def rewrite(%Conv{ path: "/bears?id=" <> id } = conv) do
    %{ conv | path: "/bears/#{id}" }
  end
  def rewrite(%Conv{ path: "/wildlife" } = conv) do
    %{ conv | path: "/wildthings" }
  end
  def rewrite(%Conv{} = conv), do: conv
end

