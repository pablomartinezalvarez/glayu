defmodule Glayu.Build.SiteAnalyzer do
	
	def nodes(root) do
		root |> scan_path([])
	end

	defp scan_path(path, nodes) do
		scan_files(File.ls!(path), path, false) ++ nodes
	end

	defp scan_files([file|other_files], path, has_regular_files) do
		child_path = Path.join(path, file)
		cond do
			File.dir?(child_path) ->
				scan_path(child_path, scan_files(other_files, path, has_regular_files))
			File.regular?(child_path) ->
				if has_regular_files do
					scan_files(other_files, path, true)
				else
					[path|scan_files(other_files, path, true)]
				end
		end
	end

	defp scan_files([], _, _) do
		[]
	end

end