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
      |> Map.put(:source, Path.absname(md_file))
      |> Map.put(:raw, raw)
      |> Map.put(:content, html_content) # Compile Markdown to HTML
      |> Map.put_new(:layout, doc_type)

    context = Map.put(context, :date, get_date(context[:date])) # date string to DateTime conversion

    if doc_type == :post || doc_type == :draft do
      context = Map.put(context, :categories, inform_categories(context[:categories])) # informed categories
      context = Map.put(context, :summary, inform_summary(context[:summary], raw))
      Map.put(context, :path, URL.path(doc_type, Permalink.from_context(context))) # document relative path
    else
      Map.put(context, :path, URL.path(doc_type, Permalink.from_context(context))) # document relative path
    end

  end

  def render(doc_context) do
    Template.render(doc_context[:type], build_context(doc_context))
  end

  def write(html, doc_context) do
    create_destination_dir(doc_context)
    write_html_file(html, doc_context)
  end

  def validate!(doc_context) do
    validate!(doc_context[:type], doc_context)
  end

  defp validate!(:draft, doc_context) do
    validate!(:post, doc_context)
  end

  defp validate!(:post, doc_context) do
    validators = [
      {:title, [Glayu.Validations.RequiredValidator.validator()]},
      {:categories, [Glayu.Validations.RequiredValidator.validator()]}
    ]
    Glayu.Validations.Validator.validate!(doc_context, validators, fn (source, field) ->
      source[field]
    end)
  end

  defp validate!(:page, doc_context) do
    validators = [
      {:title, [Glayu.Validations.RequiredValidator.validator()]}
    ]
    Glayu.Validations.Validator.validate!(doc_context, validators, fn (source, field) ->
      source[field]
    end)
  end

  defp get_date(date) do
    if date do
      Glayu.Date.parse(date)
    else
      DateTime.utc_now()
    end
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
    name_as_string = to_string name
    keys = parent ++ [Glayu.Slugger.slug(name_as_string)]
    inform_categories(subcategory_names, keys, categories ++ [%{keys: keys, name: name_as_string, path: URL.path(:category, keys)}])
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
      String.starts_with?(Path.absname(md_file), Glayu.Path.source_root(:post)) -> :post
      String.starts_with?(Path.absname(md_file), Glayu.Path.source_root(:draft)) -> :draft
      true -> :page
    end
  end

end