defmodule Glayu.EEx.Categories do

  def categories do
    Glayu.Build.SiteTree.get_children(["root"])
  end

  def subcategories(keys) do
    Glayu.Build.SiteTree.get_children(keys)
  end

end