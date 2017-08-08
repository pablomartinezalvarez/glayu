defmodule Glayu.EEx.Node do

  def parents(keys) do
    Glayu.Build.SiteTree.get_parents(keys)
  end

end
