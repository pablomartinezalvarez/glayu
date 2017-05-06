defmodule Glayu.Build.CategoriesTree do

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def put_node(keys, node, sort_fn, limit) do
    Agent.update(__MODULE__, fn tree ->
      update_node(tree, keys, node, sort_fn, limit)
    end)
  end

  def get_root_nodes do
    Agent.get(__MODULE__, fn tree ->
      Enum.map(Map.keys(tree), &(_get_node(tree, [&1])))
    end)
  end

  def get_children(keys) do
    Agent.get(__MODULE__, fn tree ->
       children_keys = get_in(tree, keys ++ [:children_keys])
       Enum.map(children_keys, &_get_node(tree, &1))
    end)
  end

  def get_node(keys) do
    Agent.get(__MODULE__, fn tree ->
      _get_node(tree, keys)
    end)
  end

  def keys do
    Agent.get(__MODULE__, fn tree ->
      _keys(tree)
    end)
  end

  def get(keys) do
    Agent.get(__MODULE__, fn tree ->
      get_in(tree, keys)
    end)
  end

  defp _get_node(tree, keys) do
    %{keys: keys, name: get_in(tree, keys ++ [:name]), path: get_in(tree, keys ++ [:path])}
  end

  defp _keys(tree) do
    nodes = Enum.map(Map.keys(tree), fn(key) ->
      List.wrap(key)
    end)
    nodes ++ _keys(tree, nodes)
  end

  defp _keys(_, []) do
    []
  end

  defp _keys(tree, keys) do
    children_keys = Enum.flat_map(keys, fn(key) ->
      get_in(tree, key ++ [:children_keys])
    end)
    children_keys ++ _keys(tree, children_keys)
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