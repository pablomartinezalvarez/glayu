defmodule Glayu.EEx do

  defmacro __using__(_opts) do
    quote do
      import Glayu.EEx.Macros
      import Glayu.EEx.Posts
      import Glayu.EEx.Categories
      import Glayu.EEx.Pages
      import Glayu.EEx.Node
      import Glayu.EEx.Tags
      alias Glayu.EEx.Date
    end
  end

end
