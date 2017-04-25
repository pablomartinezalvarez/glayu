defmodule Glayu.EEx.Macros do
  
  defmacro partial(tpl) do
    quote do
    	Glayu.Template.render_partial String.to_atom(unquote(tpl)), var!(assigns), EEx.Engine.fetch_assign!(var!(assigns), :partials)
    end
  end

end