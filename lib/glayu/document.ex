defmodule Glayu.Document do

  require EEx

  alias Glayu.FrontMatter
  alias Glayu.Permalink
  alias Glayu.Template
  alias Glayu.URL

  def parse(md_file) do

    [frontmatter|[raw|_]] = String.split(File.read!(md_file), "\n---\n")

    doc_type = doc_type(md_file)

    html_content = Earmark.as_html!(raw)

    context = FrontMatter.parse(frontmatter) # Parse front-matter
      |> Map.put(:type, doc_type)
      |> Map.put(:source, md_file)
      |> Map.put(:raw, raw)
      |> Map.put(:content, html_content) # Compile Markdown to HTML
      |> Map.put_new(:layout, doc_type)

    if doc_type == :post || doc_type == :draft do
      context = Map.put(context, :categories, inform_categories(context[:categories])) # informed categories
      context = Map.put(context, :summary, inform_summary(context[:summary], raw))
      Map.put(context, :path, URL.path(doc_type, Permalink.from_context(context))) # document relative path
    else
      Map.put(context, :path, URL.path(doc_type, Permalink.from_context(context))) # document relative path
    end

  end

  def render(doc_context, tpls) do
    Template.render(doc_context[:type], build_context(doc_context), tpls)
  end

  def write(html, doc_context) do
    create_destination_dir(doc_context)
    write_html_file(html, doc_context)
  end

  defp build_context(page_context) do
    [page: page_context, site: Glayu.Site.context()]
  end

  defp inform_summary(nil, raw) do
    raw
    |> String.split("\n")
    |> List.first
    |> Earmark.as_html!
  end

  defp inform_summary(summary, _) do
    Earmark.as_html!(summary)
  end

  defp inform_categories(names) do
    inform_categories(names, [], [])
  end

  defp inform_categories([], _, categories) do
    categories
  end

  defp inform_categories([name | subcategory_names], parent, categories) do
    keys = parent ++ [Glayu.Slugger.slug(name)]
    inform_categories(subcategory_names, keys, categories ++ [%{keys: keys, name: name, path: URL.path(:category, keys)}])
  end

  defp create_destination_dir(doc_context) do
    doc_context
    |> Permalink.from_context
    |> Glayu.Path.public_dir_from_permalink
    |> File.mkdir_p!
  end

  defp write_html_file(html, doc_context) do
    doc_context
    |> Permalink.from_context
    |> Glayu.Path.public_from_permalink
    |> File.write!(html)
  end

  defp doc_type(md_file) do
    cond do
      String.starts_with?(md_file, Glayu.Path.source_root(:post)) -> :post
      String.starts_with?(md_file, Glayu.Path.source_root(:draft)) -> :draft
      true -> :page
    end
  end

end