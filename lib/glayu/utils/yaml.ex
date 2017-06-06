defmodule Glayu.Utils.Yaml do

  def get_value(yaml_doc, key) do
    found = :proplists.get_value(key, yaml_doc)
    case found do
      :undefined -> nil
      _ -> found
    end
  end

  def get_string_value(yaml_doc, key) do
    found = :proplists.get_value(key, yaml_doc)
    case found do
      :undefined -> nil
      _ -> to_string found
    end
  end

  def to_map(yaml_doc) do
    _to_map(%{}, yaml_doc)
  end

  defp _to_map(map, []) do
    map
  end

  defp _to_map(map, [field | yaml_doc]) do
    key = String.to_atom(to_string(elem(field, 0)))
    value = elem(field, 1)
    cond do
      value == :null ->
        # skip it
        _to_map(map, yaml_doc)
      is_charlist(value) ->
        _to_map(Map.put(map, key, to_string value), yaml_doc)
      is_list(value) ->
        fn_handle_items = fn item ->
          if is_charlist(item) do
            to_string item
          else
            item
          end
        end
        _to_map(Map.put(map, key, Enum.map(value, fn_handle_items)), yaml_doc)
      true ->
        _to_map(Map.put(map, key, value), yaml_doc)
    end
  end

  defp is_charlist(value) do
    is_list(value) && (length(value) == 0 || Enum.all?(value, &(is_integer(&1)))) #to string
  end

end