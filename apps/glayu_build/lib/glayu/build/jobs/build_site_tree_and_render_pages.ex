defmodule Glayu.Build.Jobs.BuildSiteTreeAndRenderPages do

  @behaviour Glayu.Build.Jobs.Job

  @root "root"
  @md_ext ".md"

  alias Glayu.Build.JobsStore
  alias Glayu.Build.SiteTree
  alias Glayu.Document
  alias Glayu.URL

  def run(node, args) do
    docs = parse_pages(node)
    buid_site_tree(docs, args)
    render_pages(docs)
  end

  defp buid_site_tree(docs, args) do
    sort_fn = args[:sort_fn]
    num_posts =  args[:num_posts]

    SiteTree.put_pages(Enum.filter(docs, &(:page == &1[:type])))

    docs
    |> Enum.filter(&(:post == &1[:type]))
    |> Enum.sort(sort_fn)
    |> Enum.slice(0, num_posts)
    |> update_categories(sort_fn, num_posts)

  end

  defp parse_pages(node) do
    files = parse_pages(node, File.ls!(node))
    JobsStore.update_record({__MODULE__, node}, %{total_files: length(files)})
    files
  end

  defp parse_pages(node, files) do
    Enum.flat_map(files, fn(file) ->
      path = Path.join(node, file)
      if File.regular?(path) && Path.extname(path) == @md_ext do
        doc_context = Document.parse(path)
        # Updates tags
        if doc_context[:tags] do
          SiteTree.put_tags(doc_context[:tags])
        end
        [doc_context]
      else
        []
      end
    end)
  end

  defp render_pages(docs) do
    Enum.each(docs, fn(doc_context) ->
      Document.write(Document.render(doc_context), doc_context)
    end)
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