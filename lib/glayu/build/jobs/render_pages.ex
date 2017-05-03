defmodule Glayu.Build.Jobs.RenderPages do

  @behaviour Glayu.Build.Jobs.Job
  @md_ext ".md"

  alias Glayu.Build.Store
  alias Glayu.Build.ProgressMonitor
  alias Glayu.Document

  def run(node, args) do
    node
    |> parse_pages
    |> render_pages(args[:tpls])
  end

  defp parse_pages(node) do
    files = parse_pages(node, File.ls!(node), [])
    Store.update_record({__MODULE__, node}, %{total_files: length(files)})
    ProgressMonitor.add_files(length(files))
    files
  end

  defp parse_pages(node, [file|more_files], yaml_docs) do
    path = Path.join(node, file)
    if File.regular?(path) && Path.extname(path) == @md_ext do
      yaml_doc = Document.parse(path)
      parse_pages(node, more_files, [yaml_doc|yaml_docs])
    else
      parse_pages(node, more_files, yaml_docs)
    end
  end

  defp parse_pages(_, [], yaml_docs) do
    yaml_docs
  end

  defp render_pages(yaml_docs, tpls) do
    Enum.each(yaml_docs, fn(yaml_doc) ->
      Document.write(Document.render(yaml_doc, tpls), yaml_doc)
      ProgressMonitor.inc_processed()
    end)
  end

end