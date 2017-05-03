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
    _to_map(Map.put(map, key, value), yaml_doc)
  end

end