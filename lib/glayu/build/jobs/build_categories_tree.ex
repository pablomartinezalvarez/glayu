defmodule Glayu.Build.Jobs.BuildCategoriesTree do

  @behaviour Glayu.Build.Jobs.Job

  @doc_type 'type'
  @md_ext ".md"

  alias Glayu.Document
  alias Glayu.Utils.Yaml
  alias Glayu.Build.Store
  alias Glayu.Date
  alias Glayu.Permalink
  alias Glayu.Build.CategoriesTree

  def run(node, args) do
    sort_fn = args[:sort_fn]
    num_posts =  args[:num_posts]
    node
    |> parse_posts
    |> update_categories(node, sort_fn, num_posts)
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
      yaml_doc = Document.parse(path)
      if 'post' == Yaml.get_value(yaml_doc, @doc_type) do
        parse_posts(node, more_files, [yaml_doc | posts])
      else
        parse_posts(node, more_files, posts)
      end
    else
      parse_posts(node, more_files, posts)
    end
  end

  defp update_categories(posts, node, sort_fn, num_posts) do
    permalink = Permalink.parse(node_permalink(node), List.delete_at(String.split((to_string Glayu.Config.get('permalink')), "/"), -1))
    keys = Keyword.get_values(permalink, :categories)
    put_nodes(keys, posts, [], sort_fn, num_posts)
  end

  defp put_nodes([], _, _, _, _) do
    :ok
  end

  defp put_nodes([key | more_keys], posts, partial, sort_fn, num_posts) do
    keys = partial ++ [key]
    CategoriesTree.put_node(keys, %{keys: keys, posts: posts}, sort_fn, num_posts)
    put_nodes(more_keys, posts, keys, sort_fn, num_posts)
  end

  defp node_permalink(node) do
    node
    |> String.replace_prefix(Glayu.Path.source_root(:post), "")
    |> String.split("/")
    |> List.delete_at(0)
  end

end