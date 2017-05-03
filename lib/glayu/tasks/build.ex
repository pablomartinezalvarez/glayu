defmodule Glayu.Tasks.Build do

  @behaviour Glayu.Tasks.Task

  @max_posts_per_node 100
  @publication_date_yaml_doc_field 'date'

  alias Glayu.Build.SiteAnalyzer.ContainMdFiles
  alias Glayu.Build.SiteAnalyzer.Categories
  alias Glayu.Build.TaskSpawner
  alias Glayu.Build.Store
  alias Glayu.Template
  alias Glayu.Utils.Yaml
  alias Glayu.Date
  alias Glayu.Build.Jobs.RenderPages
  alias Glayu.Build.Jobs.BuildCategoriesTree

  def run(params) do
    tpls = Template.compile()
    regex = params[:regex]
    # copy_assets()
    # render_pages(root_dir(regex), regex, tpls)
    build_front_pages(posts_root_dir(regex), regex, tpls)
    #{:ok, %{results: Store.get_values(RenderPages.__info__(:module))}}
    {:ok, %{results: Store.get_values(BuildCategoriesTree.__info__(:module))}}
  end

  defp copy_assets() do
    File.cp_r(Glayu.Path.assets_source(), Glayu.Path.public_assets())
  end

  defp render_pages(root, regex, tpls) do
    nodes = ProgressBar.render_spinner([text: "Scanning site…", done: [IO.ANSI.light_cyan, "✓", IO.ANSI.reset, " Site scan completed."], frames: :braille, spinner_color: IO.ANSI.light_cyan], fn ->
      ContainMdFiles.nodes(root, compile_regex(regex))
    end)
    TaskSpawner.spawn(nodes, RenderPages, [tpls: tpls])
  end

  defp build_front_pages(root, regex, tpls) do
    nodes = ProgressBar.render_spinner([text: "Scanning site…", done: [IO.ANSI.light_cyan, "✓", IO.ANSI.reset, " Site scan completed."], frames: :braille, spinner_color: IO.ANSI.light_cyan], fn ->
      ContainMdFiles.nodes(root, compile_regex(regex))
    end)

    sort_fn = fn yaml_doc1, yaml_doc2 ->
      datetime1 = Date.parse(Yaml.get_string_value(yaml_doc1, @publication_date_yaml_doc_field))
      datetime2 = Date.parse(Yaml.get_string_value(yaml_doc2, @publication_date_yaml_doc_field))
      comp = DateTime.compare(datetime1, datetime2)
      comp == :gt || comp == :eq
    end

    TaskSpawner.spawn(nodes, BuildCategoriesTree, [sort_fn: sort_fn, num_posts: @max_posts_per_node])
    IO.puts inspect Glayu.Build.CategoriesTree.get_node(["games"])
  end

  defp compile_regex(nil) do
    nil
  end

  defp compile_regex(regex) do
    Regex.compile!(regex)
  end

  defp posts_root_dir(nil) do
    Glayu.Path.source_root(:post)
  end

  defp posts_root_dir(regex) do
    root_dir(regex)
  end

  defp root_dir(nil) do
    Glayu.Path.source_root()
  end

  defp root_dir(regex) do
    names = Regex.named_captures(~r/\/(?<path>^[^.^$*+?()[{\|]*$)\//, regex)
    path = names["path"]
    case path do
      nil -> Glayu.Path.source_root
      path -> Path.join(Glayu.Path.source_root, path)
    end
  end

end