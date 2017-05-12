defmodule Glayu.CategoryPage do

  require EEx

  alias Glayu.Build.CategoriesTree
  alias Glayu.Path

  def render(keys, tpls) do
    category = CategoriesTree.get_node(keys)
    page = %{title: category[:name], layout: :category, path: category.path,
      category: Map.put(category, :parent, CategoriesTree.get_parent(keys))}
    Glayu.Template.render(:category, [page: page, site: Glayu.Site.context()], tpls)
  end

  def write(html, keys) do
    File.mkdir_p!(Path.category_dir(keys))
    File.write!(Path.category_page(keys), html)
  end
  
end