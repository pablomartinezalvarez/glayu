defmodule Glayu.URL do

  @root "/"
  @index "index"
  @html_ext ".html"

  def root() do
    @root
  end

  def home() do
    Path.join(@root, @index <> @html_ext)
  end

  def path(:category, keys) do
    Path.join([@root] ++ keys ++ [@index <> @html_ext])
  end

  def path(_, premalink) do
    {file, partial} = List.pop_at(premalink, -1)
    Path.join([@root] ++ partial ++ [file <> @html_ext])
  end
  
end