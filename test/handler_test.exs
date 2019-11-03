defmodule HandlerTest do
  use ExUnit.Case, async: true
  import Servy.Handler, only: [handle: 1]

  test "GET /wildthings" do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 41\r
    \r
    👌 Bears, Lions, Tigers, Girraffes 👌
    """
  end

  test "GET /bears" do
    request = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 376\r\n\r\n👌 <h1>All the bears!</h1>\n\n<ul>\n  \n    <li> Teddy - Brown</li>\n  \n    <li> Smokey - Black</li>\n  \n    <li> Paddington - Brown</li>\n  \n    <li> Scarface - Grizzly</li>\n  \n    <li> Snow - Polar</li>\n  \n    <li> Brutus - Grizzly</li>\n  \n    <li> Rosie - Black</li>\n  \n    <li> Roscoe - Panda</li>\n  \n    <li> Iceman - Polar</li>\n  \n    <li> Kenai - Grizzly</li>\n  \n</ul>\n 👌\n"
  end

  test "GET /bigfoot" do
    request = """
    GET /bigfoot HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response === """
    HTTP/1.1 404 Not Found\r
    Content-Type: text/html\r
    Content-Length: 17\r
    \r
    No /bigfoot here!
    """
  end

  test "GET /bears/1" do
    request = """
    GET /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response === """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 83\r
    \r
    👌 <h1>Show bear</h1>

    <p>
    Is Teddy hibernating? <strong>true</strong>
    </p>
     👌
    """
  end

  test "DELETE /bears/1" do
    request = """
    DELETE /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response === """
    HTTP/1.1 403 Forbidden\r
    Content-Type: text/html\r
    Content-Length: 29\r
    \r
    Bear Teddy cannot be deleted!
    """
  end

  test "GET /wildlife" do
    request = """
    GET /wildlife HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response === """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 41\r
    \r
    👌 Bears, Lions, Tigers, Girraffes 👌
    """
  end

  test "GET /bears?id=1" do
    request = """
    GET /bears?id=1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response === """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 83\r
    \r
    👌 <h1>Show bear</h1>

    <p>
    Is Teddy hibernating? <strong>true</strong>
    </p>
     👌
    """
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response === """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 487\r
    \r
    👌 <h1>Lorem ipsum</h1>
    <p>
    Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    </p>
     👌
    """
  end

  test "GET /bears/new" do
    request = """
    GET /bears/new HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response === "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 250\r\n\r\n👌 <form action=\"/bears\" method=\"POST\">\n  <p>\n    Name:<br/>\n    <input type=\"text\" name=\"name\">    \n  </p>\n  <p>\n    Type:<br/>\n    <input type=\"text\" name=\"type\">    \n  </p>\n  <p>\n    <input type=\"submit\" value=\"Create Bear\">\n  </p>\n</form>\n 👌\n"
  end

  test "GET /pages/faq" do
    request = """
    GET /pages/faq HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response === """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 581\r
    \r
    👌 <h1>Frequently Asked Questions</h1>\n<ul>\n<li><p><strong>Have you really seen Bigfoot?</strong></p>\n<p>Yes! In this <a href=\"https://www.youtube.com/watch?v=v77ijOO8oAk\">totally believable video</a>!</p>\n</li>\n<li><p><strong>No, I mean seen Bigfoot <em>on the refuge</em>?</strong></p>\n<p>Oh! Not yet, but we’re still looking…</p>\n</li>\n<li><p><strong>Can you just show me some code?</strong></p>\n<p>Sure! Here’s some Elixir:</p>\n</li>\n</ul>\n<pre><code class=\"elixir\">  [&quot;Bigfoot&quot;, &quot;Yeti&quot;, &quot;Sasquatch&quot;] |&gt; Enum.random()</code></pre>\n 👌
    """
  end

  test "POST /bears" do
    request = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Baloo&type=Brown
    """

    response = handle(request)

    assert response === """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 44\r
    \r
    Create a bear with name Baloo and type Brown
    """
  end

  test "GET /api/bears" do
    request = """
    GET /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: application/json\r
    Content-Length: 615\r
    \r
    👌 [{\"type\":\"Brown\",\"name\":\"Teddy\",\"id\":1,\"hibernating\":true},{\"type\":\"Black\",\"name\":\"Smokey\",\"id\":2,\"hibernating\":false},{\"type\":\"Brown\",\"name\":\"Paddington\",\"id\":3,\"hibernating\":false},{\"type\":\"Grizzly\",\"name\":\"Scarface\",\"id\":4,\"hibernating\":true},{\"type\":\"Polar\",\"name\":\"Snow\",\"id\":5,\"hibernating\":false},{\"type\":\"Grizzly\",\"name\":\"Brutus\",\"id\":6,\"hibernating\":false},{\"type\":\"Black\",\"name\":\"Rosie\",\"id\":7,\"hibernating\":true},{\"type\":\"Panda\",\"name\":\"Roscoe\",\"id\":8,\"hibernating\":false},{\"type\":\"Polar\",\"name\":\"Iceman\",\"id\":9,\"hibernating\":true},{\"type\":\"Grizzly\",\"name\":\"Kenai\",\"id\":10,\"hibernating\":false}] 👌
    """

    assert response == expected_response
  end

  test "POST /api/bears" do
    request = """
    POST /api/bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/json\r
    Content-Length: 21\r
    \r
    {"name": "Breezly", "type": "Polar"}
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 35\r
    \r
    Created a Polar bear named Breezly!
    """
  end
end
