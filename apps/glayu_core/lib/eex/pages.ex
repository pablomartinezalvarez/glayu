defmodule Glayu.EEx.Pages do

  def pages do
    Glayu.Build.SiteTree.pages()
  end

end