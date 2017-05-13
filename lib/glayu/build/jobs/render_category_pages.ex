defmodule Glayu.Build.Jobs.RenderCategoryPages do

  @behaviour Glayu.Build.Jobs.Job

  alias Glayu.CategoryPage

  def run(node, _) do
    html = CategoryPage.render(node)
    CategoryPage.write(html, node)
  end
  
end