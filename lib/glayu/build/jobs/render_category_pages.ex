defmodule Glayu.Build.Jobs.RenderCategoryPages do

  @behaviour Glayu.Build.Jobs.Job

  alias Glayu.CategoryPage

  def run(node, args) do
    html = CategoryPage.render(node, args[:tpls])
    CategoryPage.write(html, node)
  end
  
end