defmodule Glayu.EEx.Macros do
  
  alias Glayu.EEx.Macros

  defmacro partial(tpl) do
    quote do
      Macros.Partial.render String.to_atom(unquote(tpl)), var!(assigns), EEx.Engine.fetch_assign!(var!(assigns), :partials)
    end
  end

end