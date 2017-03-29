defmodule GlayuTest do
  use ExUnit.Case
  doctest Glayu

  test "the truth" do
    
    IO.puts EEx.eval_string(" <%= @content %>\n ", [assigns: [content: "<p>A new Glayu post</p>\n"]])
  end
end
