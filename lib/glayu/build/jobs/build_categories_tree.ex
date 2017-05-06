defmodule Glayu.Build.Jobs.BuildCategoriesTree do

  @behaviour Glayu.Build.Jobs.Job

  @md_ext ".md"

  alias Glayu.Document
  alias Glayu.Build.Store
  alias Glayu.URL
  alias Glayu.Build.CategoriesTree

  def run(node, args) do
    sort_fn = args[:sort_fn]
    num_posts =  args[:num_posts]

    node
    |> parse_posts
    |> Enum.sort(sort_fn)
    |> Enum.slice(0, num_posts)
    |> update_categories(sort_fn, num_posts)

  end

  defp parse_posts(node) do
    posts = parse_posts(node, File.ls!(node), [])
    Store.update_record({__MODULE__, node}, %{total_files: length(posts)})
    posts
  end

  defp parse_posts(_, [], posts) do
    posts
  end

  defp parse_posts(node, [file | more_files], posts) do
    path = Path.join(node, file)
    if File.regular?(path) && Path.extname(path) == @md_ext do
      doc_context = Document.parse(path)
      if :post == doc_context[:type] do
        parse_posts(node, more_files, [doc_context | posts])
      else
        parse_posts(node, more_files, posts)
      end
    else
      parse_posts(node, more_files, posts)
    end
  end

  defp update_categories(posts, sort_fn, num_posts) do
    if length(posts) > 0 do
      put_nodes(List.first(posts).categories, posts, sort_fn, num_posts)
    end
  end

  defp put_nodes([], _, _, _) do
    []
  end

  defp put_nodes([category | children], posts, sort_fn, num_posts) do
    if length(children) > 0 do
      CategoriesTree.put_node(category.keys, %{keys: category.keys, name: category.name, posts: posts, path: category.path, children_keys: [List.first(children).keys]}, sort_fn, num_posts)
    else
      CategoriesTree.put_node(category.keys, %{keys: category.keys, name: category.name, posts: posts, path: category.path, children_keys: []}, sort_fn, num_posts)
    end
    put_nodes(children, posts, sort_fn, num_posts)
  end

end