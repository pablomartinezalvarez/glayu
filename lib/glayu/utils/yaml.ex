defmodule Glayu.Utils.Yaml do

  def get_value(yaml_doc, key) do
    found = List.keyfind(yaml_doc, key, 0)
    case found do
      nil -> nil
      {_key, value} -> value
    end
  end

  def get_string_value(yaml_doc, key) do
    found = List.keyfind(yaml_doc, key, 0)
    case found do
      nil -> nil
      {_key, value} -> to_string value
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
      is_list_of_charlists(value) ->
        _to_map(Map.put(map, key, Enum.map(value, &(to_string &1))), yaml_doc)
      true ->
        _to_map(Map.put(map, key, value), yaml_doc)
    end
  end

  defp is_charlist(value) do
    is_list(value) && (length(value) == 0 || is_integer(List.first(value))) #to string
  end

  defp is_list_of_charlists(value) do
    is_list(value) && length(value) > 0 && is_list(List.first(value)) &&
      (length(List.first(value)) == 0 || is_integer(List.first(List.first(value))))
  end

end