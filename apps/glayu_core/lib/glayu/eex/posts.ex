defmodule Glayu.EEx.Posts do

  def posts() do
    Glayu.Build.SiteTree.get(["root"] ++ [:posts]) || []
  end

  def posts(options) do
    posts()
    |> sort(options[:sort_fn])
    |> slice(options[:limit])
  end

  def category_posts(keys) do
    Glayu.Build.SiteTree.get(keys ++ [:posts]) || []
  end

  def category_posts(keys, options) do
    category_posts(keys)
    |> sort(options[:sort_fn])
    |> slice(options[:limit])
  end

  defp sort(posts, nil) do
    posts
  end

  defp sort(posts, sort_fn) do
    Enum.sort(posts, sort_fn)
  end

  defp slice(posts, nil) do
    posts
  end

  defp slice(posts, limit) do
    Enum.slice(posts, 0, limit)
  end

end