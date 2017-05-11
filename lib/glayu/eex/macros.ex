defmodule Glayu.EEx.Macros do

  defmacro partial(tpl) do
    quote do
      Glayu.EEx.Macros.Partial.render String.to_atom(unquote(tpl)), var!(assigns), EEx.Engine.fetch_assign!(var!(assigns), :partials)
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
      Glayu.EEx.Macros.Posts.posts()
    end
  end

  defmacro posts(options) do
    quote do
      Glayu.EEx.Macros.Posts.posts(unquote(options))
    end
  end

  defmacro category_posts(keys) do
    quote do
      Glayu.EEx.Macros.Posts.category_posts(unquote(keys))
    end
  end

  defmacro category_posts(keys, options) do
    quote do
      Glayu.EEx.Macros.Posts.category_posts(unquote(keys), unquote(options))
    end
  end

end