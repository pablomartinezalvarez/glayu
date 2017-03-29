defmodule Glayu.Build.NodeProcessor do

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
		node 
		|> list_md_files
		|> compile_md_files
	end

	defp list_md_files(node) do
		_list_md_files(node, File.ls!(node), [])
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
		|> Enum.each(&Glayu.Document.compile(&1))
	end

end