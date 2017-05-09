defmodule Glayu.EEx.Macros do

  alias Glayu.EEx.Macros

  defmacro partial(tpl) do
    quote do
      Macros.Partial.render String.to_atom(unquote(tpl)), var!(assigns), EEx.Engine.fetch_assign!(var!(assigns), :partials)
    end
  end

  defmacro categories do
    quote do
      Glayu.Build.CategoriesTree.get_children(["root"])
    end
  end

  defmacro subcategories(keys) do
    quote do
      Glayu.Build.CategoriesTree.get_children(unquote(keys))
    end
  end

  defmacro posts do
    quote do
      Glayu.Build.CategoriesTree.get(["root"] ++ [:posts])
    end
  end

  defmacro posts(keys) do
    quote do
      Glayu.Build.CategoriesTree.get(unquote(keys) ++ [:posts])
    end
  end

end