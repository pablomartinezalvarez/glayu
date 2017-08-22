defmodule Glayu.CategoryPage do

  require EEx

  alias Glayu.Build.SiteTree
  alias Glayu.Path

  def render(keys) do
    category = SiteTree.get_node(keys)
    page = %{title: category[:name], layout: :category, type: :category, path: category.path,
      category: Map.put(category, :parent, SiteTree.get_parent(keys))}
    Glayu.Template.render(:category, [page: page, site: Glayu.Site.context()])
  end

  def write(html, keys) do
    File.mkdir_p!(Path.category_dir(keys))
    File.write!(Path.category_page(keys), html)
  end
  
end