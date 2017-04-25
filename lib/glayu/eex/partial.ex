defmodule Glayu.EEx.Macros.Partial do

	def render(partial, context, tpls) do
		tpl = tpls[partial]
		{value, _} = Code.eval_quoted tpl, [assigns: context] 
		value
	end

end