defmodule DocTest do
  use ExUnit.Case, async: true

  doctest Servy
  doctest Servy.Parser
  doctest Servy.Handler
  doctest Servy.Plugins
end
