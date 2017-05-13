defmodule Glayu.Permalink do

  def parse(permalink) do
    parse_expression(String.split((to_string Glayu.Config.get('permalink')), "/"), permalink, [])
  end

  def parse(permalink, expression) do
    parse_expression(expression, permalink, [])
  end

  def from_context(doc_context) do
    from_context(doc_context[:type], doc_context)
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

    [token | more_tokens] = expression
    [value | more_values] = values

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

  defp from_context(:draft, doc_context) do
    from_context(:post, doc_context)
  end

  defp from_context(:post, doc_context) do
    pattern = to_string Glayu.Config.get('permalink')
    extract_permalink(pattern, doc_context)
  end

  defp from_context(:page, doc_context) do
    doc_context[:source]
    |> remove_base_dir
    |> Path.split
    |> List.delete_at(0)
  end

  defp remove_base_dir(file) do
    file_no_ext = String.replace(file, ".md", "")
    cond do
      String.starts_with?(file_no_ext, Glayu.Path.source_root()) ->
        String.replace_prefix(file_no_ext, Glayu.Path.source_root(), "")
      String.starts_with?(file_no_ext, Glayu.Path.public_root()) ->
        String.replace_prefix(file_no_ext, Glayu.Path.public_root(), "")
      true ->
        file_no_ext
    end
  end

  defp extract_permalink(pattern, doc_context) do
    extract(String.split(pattern, "/"), [], doc_context)
  end

  defp extract([], permalink, _) do
    permalink
  end

  defp extract([token|more_tokens], permalink, doc_context) do
    extract(more_tokens, permalink ++ extract_value(String.to_atom(token), doc_context), doc_context)
  end

  defp extract_value(:categories, doc_context) do
    categories = doc_context[:categories]
    case categories do
      nil -> []
      categories ->
        Enum.map(categories, fn(category) -> Glayu.Slugger.slug(category.name) end)
    end
  end

  defp extract_value(:year, doc_context) do
    date = doc_context[:date]
    case date do
      nil -> []
      date ->
        [Glayu.Date.year(date)]
    end
  end

  defp extract_value(:month, doc_context) do
    date = doc_context[:date]
    case date do
      nil -> []
      date ->
        [Glayu.Date.month(date)]
    end
  end

  defp extract_value(:day, doc_context) do
    date = doc_context[:date]
    case date do
      nil -> []
      date ->
        [Glayu.Date.day(date)]
    end
  end

  defp extract_value(:title, doc_context) do
    title = doc_context[:title]
    case title do
      nil -> []
      title -> [Glayu.Slugger.slug(title)]
    end
  end

end