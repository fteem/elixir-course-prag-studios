defmodule Servy.API.BearController do
  def put_resp_content_type(conv, content_type) do
    %{ conv | resp_headers: %{ conv.resp_headers | "Content-Type" => content_type } }
  end

  def index(conv) do
    json =
      Servy.Bear.all
      |> Poison.encode!
    
    conv = put_resp_content_type(conv, "application/json")
    %{ conv | status: 200, resp_body: json }
  end

  def create(conv, params) do
    conv = put_resp_content_type(conv, "text/html")
    %{ conv | status: 201, resp_body: "Created a #{params["type"]} bear named #{params["name"]}!" }
  end
end
