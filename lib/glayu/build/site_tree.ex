defmodule Glayu.Build.SiteTree do

  @root "root"

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def put_node(keys, node, sort_fn, limit) do
    Agent.update(__MODULE__, fn tree ->
        update_node(tree, normalize(keys), node, sort_fn, limit)
    end)
  end

  def get_children(keys) do
    Agent.get(__MODULE__, fn tree ->
      children_keys = get_in(tree, normalize(keys) ++ [:children_keys])
      Enum.sort(Enum.map(children_keys, &_get_node(tree, normalize(&1))))
    end)
  end

  def get_parent(keys) do
    Agent.get(__MODULE__, fn tree ->
      parent_keys = get_in(tree, normalize(keys) ++ [:parent_keys])
      if length(parent_keys) > 0 do
        _get_node(tree, normalize(parent_keys))
      else
        nil
      end
    end)
  end

  def get_node(keys) do
    Agent.get(__MODULE__, fn tree ->
        _get_node(tree, normalize(keys))
    end)
  end

  def keys do
    Agent.get(__MODULE__, fn tree ->
      if Map.has_key?(tree, @root) do
        Enum.sort(_keys(tree, [[@root]]))
      else
        []
      end
    end)
  end

  def put_tags(tags) do
    Agent.update(__MODULE__, fn tree ->
      _put_tags(tree, tags)
    end)
  end

  def tags do
    Agent.get(__MODULE__, fn tree ->
      Enum.sort(MapSet.to_list(tree[:tags]))
    end)
  end

  def get(keys) do
    Agent.get(__MODULE__, fn tree ->
      get_in(tree, normalize(keys))
    end)
  end

  defp normalize(keys) do
    if List.first(keys) == @root do
      keys
    else
      [@root] ++ keys
    end
  end

  defp _get_node(tree, keys) do
    %{keys: keys, name: get_in(tree, keys ++ [:name]), path: get_in(tree, keys ++ [:path])}
  end

  defp _keys(_, []) do
    []
  end

  defp _keys(tree, keys) do
    children_keys = Enum.flat_map(keys, fn(key) ->
      get_in(tree, normalize(key) ++ [:children_keys])
    end)
    children_keys ++ _keys(tree, children_keys)
  end

  defp _put_tags(tree, tags) do
    {_, updated_tree} = get_and_update_in(tree, [:tags], fn (tags_set) ->
      if tags_set do
        {tags_set, MapSet.union(tags_set, MapSet.new(tags))}
      else
        {nil, MapSet.new(tags)}
      end
    end)
    updated_tree
  end

  defp update_node(tree, keys, node, sort_fn, num_posts) do
    {_, updated_tree} = get_and_update_in(tree, keys, fn (previous) ->
      if previous do

        posts = previous[:posts] ++ node[:posts]
          |> Enum.sort(sort_fn)
          |> Enum.slice(0, num_posts)

        if Enum.member?(previous[:children_keys], List.flatten(node[:children_keys])) do
          {previous, Map.merge(previous, %{posts: posts})}
        else
          {previous, Map.merge(previous, %{posts: posts, children_keys: previous[:children_keys] ++ node[:children_keys]})}
        end

      else
        {nil, node}
      end
    end)
    updated_tree
  end

end