defmodule Glayu.EEx.GlayuEngine do

  use EEx.Engine

  def fetch_assign!(assigns, key) do
    case Access.fetch(assigns, key) do
      {:ok, val} ->
        val
      :error ->
        keys = Enum.map(assigns, &elem(&1, 0))
        IO.warn "assign @#{key} not available in EEx template. " <>
                "Please ensure all assigns are given as options. " <>
                "Available assigns: #{inspect keys}"
        nil
    end
  end

  def handle_assign({:@, meta, [{name, _, atom}]}) when is_atom(name) and is_atom(atom) do
    line = meta[:line] || 0
    quote line: line, do: Glayu.EEx.GlayuEngine.fetch_assign!(var!(assigns), unquote(name))
  end

  def handle_assign(arg) do
    arg
  end

  def handle_expr(buffer, mark, expr) do
    expr = Macro.prewalk(expr, &handle_assign/1)
    super(buffer, mark, expr)
  end

end