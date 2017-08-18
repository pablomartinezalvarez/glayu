defmodule Glayu.Build.Jobs.BuildSiteTree do

  @behaviour Glayu.Build.Jobs.Job

  @md_ext ".md"
  @root "root"

  alias Glayu.Document
  alias Glayu.Build.JobsStore
  alias Glayu.URL
  alias Glayu.Build.SiteTree

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
    JobsStore.update_record({__MODULE__, node}, %{total_files: length(posts)})
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
        if doc_context[:tags] do
          SiteTree.put_tags(doc_context[:tags])
        end
        parse_posts(node, more_files, [doc_context | posts])
      else
        SiteTree.put_pages([doc_context])
        parse_posts(node, more_files, posts)
      end
    else
      parse_posts(node, more_files, posts)
    end
  end

  defp update_categories(posts, sort_fn, num_posts) do
    if length(posts) > 0 do
      root_node = %{keys: [@root], name: "Home", path: URL.home()}
      categories = [root_node] ++ List.first(posts).categories
      put_nodes(categories, [], posts, sort_fn, num_posts)
    end
  end

  defp put_nodes([], _, _, _, _) do
    []
  end

  defp put_nodes([category | children], parent_keys, posts, sort_fn, num_posts) do
    if length(children) > 0 do
      node = %{keys: category.keys, name: category.name, posts: posts, path: category.path, children_keys: [List.first(children).keys], parent_keys: parent_keys}
      if List.first(category.keys) == @root do
        SiteTree.put_node(category.keys, node, sort_fn, num_posts)
      else
        SiteTree.put_node(category.keys, node, sort_fn, num_posts)
      end
    else
      node = %{keys: category.keys, name: category.name, posts: posts, path: category.path, children_keys: [], parent_keys: parent_keys}
      if List.first(category.keys) == @root do
        SiteTree.put_node(category.keys, node, sort_fn, num_posts)
      else
        SiteTree.put_node(category.keys, node, sort_fn, num_posts)
      end
    end
    put_nodes(children, category.keys, posts, sort_fn, num_posts)
  end

end