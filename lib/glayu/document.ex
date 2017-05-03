defmodule Glayu.Document do

  require EEx

  alias Glayu.Utils.Yaml

  def parse(md_file) do
    md = File.read! md_file
    [frontmatter|raw] = String.split md, "\n---\n"
    Enum.concat([{'type', doc_type(md_file)}, {'md_file', md_file}, {'raw', raw}] , Glayu.FrontMatter.parse frontmatter)
  end

  def render(yaml_doc, tpls) do
    type = Yaml.get_string_value(yaml_doc, 'layout') || Yaml.get_string_value(yaml_doc, 'type')
    Glayu.Template.render(type, Yaml.get_value(yaml_doc, 'raw'), [page: Yaml.to_map(yaml_doc)], tpls)
  end

  def write(html, yaml_doc) do
    create_destination_dir(yaml_doc)
    write_html_file(html, yaml_doc)
  end

  defp create_destination_dir(yaml_doc) do
    yaml_doc
    |> Glayu.Permalink.from_yaml_doc
    |> Glayu.Path.public_dir_from_permalink
    |> File.mkdir_p!
  end

  defp write_html_file(html, yaml_doc) do
    yaml_doc
    |> Glayu.Permalink.from_yaml_doc
    |> Glayu.Path.public_from_permalink
    |> File.write!(html)
  end

  defp doc_type(md_file) do
    cond do
      String.starts_with?(md_file, Glayu.Path.source_root(:post)) -> 'post'
      String.starts_with?(md_file, Glayu.Path.source_root(:draft)) -> 'draft'
      true -> 'page'
    end
  end

end