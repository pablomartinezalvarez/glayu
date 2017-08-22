defmodule Glayu.EEx.Partial do

  alias Glayu.Build.TemplatesStore

  def render(partial, context) do
    tpl = TemplatesStore.get_partial(partial)
    {value, _} = Code.eval_quoted(tpl, [assigns: context])
    value
  end

end