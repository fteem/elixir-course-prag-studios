defmodule Reminder do
  def remind(content, seconds) do
    spawn(fn ->
      :timer.sleep(seconds * 1000); IO.puts content
    end)
  end
end
