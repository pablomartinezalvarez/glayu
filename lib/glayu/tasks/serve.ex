defmodule Glayu.Tasks.Serve do

  @behaviour Glayu.Tasks.Task

  @max_posts_per_node 100

  def run(params) do

    Application.start(:cowboy)
    Application.start(:plug)

    Glayu.Config.load_config()
    Glayu.SiteChecker.check_site!()
    {:ok, _} = Glayu.PreviewServer.Supervisor.start_link(params)
    Glayu.Build.TemplatesStore.add_templates(Glayu.Template.compile())

    scan_site()

    ["🐦  Preview server started at port ", :light_cyan, "http://localhost:#{params[:port]}/"]
    |> IO.ANSI.format
    |> IO.puts

    :timer.sleep(:infinity)

  end

  defp scan_site() do

    nodes = ProgressBar.render_spinner([text: "Scanning site…", done: [IO.ANSI.light_cyan, "✓", IO.ANSI.reset, " Site scan completed."], frames: :braille, spinner_color: IO.ANSI.light_cyan], fn ->
      nodes = Glayu.Build.SiteAnalyzer.ContainMdFiles.nodes(Glayu.Path.source_root(), nil)

      sort_fn = fn doc_context1, doc_context2 ->
        comp = DateTime.compare(doc_context1[:date], doc_context2[:date])
        comp == :gt || comp == :eq
      end

      Glayu.Build.TaskSpawner.spawn(nodes, Glayu.Build.Jobs.BuildSiteTree, [sort_fn: sort_fn, num_posts: @max_posts_per_node])
      nodes
    end)

    {status, resume} = Glayu.Build.JobResume.resume(Glayu.Build.Jobs.BuildSiteTree.__info__(:module))

    if status == :ok do
      IO.puts IO.ANSI.format([:light_cyan, "└── #{length(Glayu.Build.SiteTree.keys())}", :reset , " categories and ", :light_cyan, "#{resume.files}", :reset , " posts added to the site tree."])
      {:ok, [nodes: nodes]}
    else
      {:error, IO.ANSI.format([["Unable to build Site Tree: "] | resume.errors])}
    end
  end

end