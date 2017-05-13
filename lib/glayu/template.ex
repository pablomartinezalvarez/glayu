defmodule Glayu.Template do

  alias Glayu.Build.TemplatesStore

  def compile() do
    [layouts: compile_tpls(Glayu.Path.layouts_dir()), partials: compile_tpls(Glayu.Path.partials_dir())]
  end

  def render(layout, context) do
    base_layout = TemplatesStore.get_layout(:layout)
    inner_layout = TemplatesStore.get_layout(layout)
    {inner_html, _} = Code.eval_quoted inner_layout, [assigns: context]
    {html, _} = Code.eval_quoted base_layout, [assigns: Enum.concat(context, [inner: inner_html])]
    html
  end

  defp compile_tpls(base_path) do
    Enum.map(File.ls!(base_path), fn(file) ->
      compiled = EEx.compile_file(Path.join(base_path, file), [engine: Glayu.EEx.GlayuEngine])
      [name|_] = String.split(file, ".")
      {String.to_atom(name), compiled}
    end)
  end

end