defmodule Glayu.Permalink do

  alias Glayu.Utils.Yaml

  def parse(permalink) do
    parse_expression(String.split((to_string Glayu.Config.get('permalink')), "/"), permalink, [])
  end

  def parse(permalink, expression) do
    parse_expression(expression, permalink, [])
  end

  def from_yaml_doc(yaml_doc) do
    type = String.to_atom(Yaml.get_string_value(yaml_doc, 'type'))
    from_yaml_doc(type, yaml_doc)
  end

  defp parse_expression([], [], parsed) do
    parsed
  end

  defp parse_expression([], _, _) do
    false
  end

  defp parse_expression(_, [], _) do
    false
  end

  defp parse_expression(expression, values, parsed) do

    [token|more_tokens] = expression
    [value|more_values] = values

    token_as_atom = String.to_atom(token)

    if match_token?(token_as_atom, value) do
      if token_as_atom == :categories do
        parse_expression(expression, more_values, parsed ++ [{token_as_atom, value}]) ||
        parse_expression(more_tokens, more_values, parsed ++ [{token_as_atom, value}])
      else
        parse_expression(more_tokens, more_values, parsed ++ [{token_as_atom, value}])
      end
    end
  end

  defp match_token?(:categories, value) do
    Regex.match?(~r/^[a-z0-9-]*$/, value)
  end

  defp match_token?(:title, value) do
    Regex.match?(~r/^[a-z0-9-]*$/, value)
  end

  defp match_token?(:year, value) do
    Regex.match?(~r/^[0-9][0-9][0-9][0-9]$/, value)
  end

  defp match_token?(:month, value) do
    Regex.match?(~r/^[0-9][0-9]$/, value) && String.to_integer(value) > 0 && String.to_integer(value) <= 12
  end

  defp match_token?(:day, value) do
    Regex.match?(~r/^[0-9][0-9]$/, value) && String.to_integer(value) > 0 && String.to_integer(value) <= 31
  end

  defp from_yaml_doc(:draft, yaml_doc) do
    from_yaml_doc(:post, yaml_doc)
  end

  defp from_yaml_doc(:post, yaml_doc) do
    pattern = to_string Glayu.Config.get('permalink')
    extract_permalink(pattern, yaml_doc)
  end

  defp from_yaml_doc(:page, yaml_doc) do

    md_file = Yaml.get_string_value(yaml_doc, 'md_file')

    md_file
    |> remove_base_dir
    |> Path.split
    |> List.delete_at(0)

  end

  defp remove_base_dir(file) do
    file_no_ext = String.replace_prefix(file, ".md", "")
    cond do
      String.starts_with?(file_no_ext, Glayu.Path.source_root()) ->
        String.replace_prefix(file, Glayu.Path.source_root(), "")
      String.starts_with?(file_no_ext, Glayu.Path.public_root()) ->
        String.replace_prefix(file, Glayu.Path.public_root(), "")
      true ->
        file_no_ext
    end
  end

  defp extract_permalink(pattern, yaml_doc) do
    extract(String.split(pattern, "/"), [], yaml_doc)
  end

  defp extract([], permalink, _) do
    permalink
  end

  defp extract([token|more_tokens], permalink, yaml_doc) do
    extract(more_tokens, permalink ++ extract_value(String.to_atom(token), yaml_doc), yaml_doc)
  end

  defp extract_value(:categories, yaml_doc) do
    categories = Yaml.get_value(yaml_doc, 'categories')
    case categories do
      nil -> []
      categories ->
        Enum.map(categories, fn(category) -> Glayu.Slugger.slug(to_string category) end)
    end
  end

  defp extract_value(:year, yaml_doc) do
    date = Yaml.get_string_value(yaml_doc, 'date')
    case date do
      nil -> []
      date ->
        datetime = Glayu.Date.parse(date)
        [Glayu.Date.year datetime]
    end
  end

  defp extract_value(:month, yaml_doc) do
    date = Yaml.get_string_value(yaml_doc, 'date')
    case date do
      nil -> []
      date ->
        datetime = Glayu.Date.parse(date)
        [Glayu.Date.month datetime]
    end
  end

  defp extract_value(:day, yaml_doc) do
    date = Yaml.get_string_value(yaml_doc, 'date')
    case date do
      nil -> []
      date ->
        datetime = Glayu.Date.parse(date)
        [Glayu.Date.day datetime]
    end
  end

  defp extract_value(:title, yaml_doc) do
    title = Yaml.get_string_value(yaml_doc, 'title')
    case title do
      nil -> []
      title -> [Glayu.Slugger.slug(title)]
    end
  end

end