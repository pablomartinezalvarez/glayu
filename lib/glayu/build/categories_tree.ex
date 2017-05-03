defmodule Glayu.Build.CategoriesTree do

  @special_keys [:posts, :keys]

  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def put_node(keys, node) do
    Agent.update(__MODULE__, fn tree ->
      update_node(tree, keys, node)
    end)
  end

  def put_node(keys, node, sort_fn, limit) do
    Agent.update(__MODULE__, fn tree ->
      update_node(tree, keys, node, sort_fn, limit)
    end)
  end

  def get_node(keys) do
    Agent.get(__MODULE__, fn tree ->
      get_in(tree, keys)
    end)
  end

  def get_children(keys) do
    Agent.get(__MODULE__, fn tree ->
      Enum.map(Map.keys(get_in(tree, keys)) -- @special_keys, fn(key) ->
        keys ++ [key]
      end)
    end)
  end

  def get_children() do
    Agent.get(__MODULE__, fn tree ->
      Enum.map(Map.keys(tree), fn(key) ->
        List.wrap(key)
      end)
    end)
  end

  defp update_node(tree, keys, node, sort_fn, num_posts) do
    {_, updated_tree} = get_and_update_in(tree, keys, fn (previous) ->
      if previous do
          posts =
            previous[:posts] ++ node[:posts]
            |> Enum.sort(sort_fn)
            |> Enum.slice(0, num_posts)

          {previous, %{keys: keys, posts: posts}}
      else
        posts =
          node[:posts]
          |> Enum.sort(sort_fn)
          |> Enum.slice(0, num_posts)

        {nil, %{keys: keys, posts: posts}}
      end
    end)
    updated_tree
  end

  defp update_node(tree, keys, node) do
    {_, updated_tree} = get_and_update_in(tree, keys, fn (previous) ->
      if previous do
        {previous, %{keys: keys, posts: previous[:posts] ++ node[:posts]}}
      else
        {nil, node}
      end
    end)
    updated_tree
  end

end