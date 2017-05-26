defmodule Glayu.Slugger do

  def slug(title) do
    Slugger.slugify_downcase(title)
  end

end