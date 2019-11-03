defmodule Servy.BearController do
  alias Servy.Conv
  alias Servy.Bear
  alias Servy.BearView

  def index(conv) do
    bears = Bear.all

    %Conv{ conv | resp_body: BearView.index(bears), status: 200 }
  end

  def show(conv, %{ "id" => id }) do
    bear = Bear.get(id)

    %Conv{ conv | resp_body: BearView.show(bear), status: 200 }
  end

  def delete(conv, %{ "id" => id }) do
    bear = Bear.get(id)
    %Conv{ conv | resp_body: "Bear #{bear.name} cannot be deleted!", status: 403 }
  end
end
