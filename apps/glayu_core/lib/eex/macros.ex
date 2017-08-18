defmodule Glayu.EEx.Macros do

  defmacro partial(tpl) do
    quote do
      Glayu.EEx.Partial.render(String.to_atom(unquote(tpl)), var!(assigns))
    end
  end

end