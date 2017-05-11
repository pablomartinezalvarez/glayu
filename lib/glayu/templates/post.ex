defmodule Glayu.Templates.Post do

  def tpl(title) do
    """
    ---
    title: #{title}
    date: #{Glayu.Date.now}
    author:
    featured_image:
    score: 10
    summary: A new Glayu post
    categories:
    - Software
    - Static Sites
    tags:
    - Glayu
    - Elixir
    ---
    A new Glayu post
    """
  end

end