defmodule Servy.MarkdownHandler do
  def handle_md({:ok, content}, conv) do
    case Earmark.as_html(content) do
      {:ok, html_doc, _} ->
        %{conv | resp_body: html_doc, status: 200}

      {:error, _, reason} ->
        %{conv | resp_body: "File error: #{reason}", status: 500}
    end
  end

  def handle_md({:error, reason}, conv) do
    %{conv | resp_body: "File error: #{reason}", status: 500}
  end
end
