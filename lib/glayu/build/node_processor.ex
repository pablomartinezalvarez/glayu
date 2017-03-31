defmodule Glayu.Build.NodeProcessor do

	alias Glayu.Build.Store;
	alias Glayu.Build.ProgressMonitor;

	def process(node) do
		try do
			node |> _process
		rescue error ->
      		exit {:shutdown, error}
    	catch key, error ->
      		exit {:shutdown, {key, error}}
		end
	end

	defp _process(node) do
		Store.put_record(%Glayu.Build.Record{node: node, status: :running, pid: self()})
		node 
		|> list_md_files
		|> compile_md_files
	end

	defp list_md_files(node) do
		files = _list_md_files(node, File.ls!(node), [])
		Store.update_record(node, %{total_files: length(files)})
		ProgressMonitor.add_files(length(files))
		files
	end

	defp _list_md_files(node, [file|more_files], md_files) do
		path = Path.join(node, file)
		cond do
			File.regular?(path) && Path.extname(path) == ".md" ->
				_list_md_files(node, more_files, [path|md_files])
			true ->
				_list_md_files(node, more_files, md_files)
		end
	end

	defp _list_md_files(_, [], md_files) do
		md_files
	end

	defp compile_md_files(files) do
		files
		|> Enum.each(fn(md_file) -> 
			Glayu.Document.compile(md_file)
			ProgressMonitor.inc_processed()
		end)
	end

end