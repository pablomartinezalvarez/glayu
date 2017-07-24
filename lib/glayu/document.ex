defmodule Glayu.Document do

  require EEx

  alias Glayu.FrontMatter
  alias Glayu.Permalink
  alias Glayu.Template
  alias Glayu.URL

  def parse(md_file) do

    [frontmatter|[raw|_]] = String.split(File.read!(md_file), "\n---\n", parts: 2)

    doc_type = doc_type(md_file)

    html_content = Earmark.as_html!(raw)

    context = FrontMatter.parse(frontmatter) # Parse front-matter
      |> Map.put(:type, doc_type)
      |> Map.put(:source, Path.absname(md_file))
      |> Map.put(:raw, raw)
      |> Map.put(:content, html_content) # Compile Markdown to HTML
      |> inform_layout(doc_type)

    context = Map.put(context, :date, get_date(context[:date])) # date string to DateTime conversion

    if doc_type == :post || doc_type == :draft do

      # TODO Think! Why context |> inform_categories doesn't work?
      context = inform_categories(context)

      context
      |> inform_summary(raw)
      |> Map.put(:path, URL.path(doc_type, Permalink.from_context(context)))  # document relative path

    else
      Map.put(context, :path, URL.path(doc_type, Permalink.from_context(context))) # document relative path
    end

  end

  def render(doc_context) do
    Template.render(doc_context[:layout], build_context(doc_context))
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

  # Layout is included on front-matter
  defp inform_layout(context = %{layout: layout}, _) do
    Map.put(context, :layout, String.to_atom(layout))
  end

  # The layout for a drat is the post layout
  defp inform_layout(context, :draft) do
    Map.put(context, :layout, :post)
  end

  defp inform_layout(context, doc_type) do
    Map.put(context, :layout, doc_type)
  end

  # Summary is included on front-matter
  defp inform_summary(context = %{summary: summary}, _) do
    Map.put(context, :summary, Earmark.as_html!(summary))
  end

  defp inform_summary(context, raw) do
    html = raw
      |> String.split("\n")
      |> List.first
      |> Earmark.as_html!

      Map.put(context, :summary, html)
  end

  defp inform_categories(context) do
    Map.put(context, :categories, _inform_categories(context[:categories], [], []))
  end

  defp _inform_categories([], _, categories) do
    categories
  end

  defp _inform_categories([name | subcategory_names], parent, categories) do
    name_as_string = to_string name
    keys = parent ++ [Glayu.Slugger.slug(name_as_string)]
    _inform_categories(subcategory_names, keys, categories ++ [%{keys: keys, name: name_as_string, path: URL.path(:category, keys)}])
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