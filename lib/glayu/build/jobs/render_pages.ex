defmodule Glayu.Build.Jobs.RenderPages do

  @behaviour Glayu.Build.Jobs.Job
  @md_ext ".md"

  alias Glayu.Build.JobsStore
  alias Glayu.Build.ProgressMonitor
  alias Glayu.Document

  def run(node, _) do
    node
    |> parse_pages
    |> render_pages
  end

  defp parse_pages(node) do
    files = parse_pages(node, File.ls!(node), [])
    JobsStore.update_record({__MODULE__, node}, %{total_files: length(files)})
    ProgressMonitor.add_files(length(files))
    files
  end

  defp parse_pages(node, [file|more_files], docs) do
    path = Path.join(node, file)
    if File.regular?(path) && Path.extname(path) == @md_ext do
      doc = Document.parse(path)
      parse_pages(node, more_files, [doc|docs])
    else
      parse_pages(node, more_files, docs)
    end
  end

  defp parse_pages(_, [], docs) do
    docs
  end

  defp render_pages(docs) do
    Enum.each(docs, fn(doc_context) ->
      Document.write(Document.render(doc_context), doc_context)
      ProgressMonitor.inc_processed()
    end)
  end

end