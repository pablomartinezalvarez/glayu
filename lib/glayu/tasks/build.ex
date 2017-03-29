defmodule Glayu.Tasks.Build do

	@behaviour Glayu.Tasks.Task

	alias Glayu.Build.SiteAnalyzer
	alias Glayu.Build.TaskSpawner

	def run(params) do
		params[:regex]
		|> root_dir
		|> SiteAnalyzer.nodes(compile_regex(params[:regex]))
		|> TaskSpawner.spawn
		|> print_report
		{:ok, ""}
	end

	defp print_report(results) do
		IO.puts inspect results
	end

	defp compile_regex(nil) do
		nil
	end

	defp compile_regex(regex) do
		Regex.compile!(regex)
	end

	defp root_dir(nil) do
		Glayu.Path.source_root
	end

	defp root_dir(regex) do
		names = Regex.named_captures(~r/\/(?<path>[^.^$*+?()[{\|]*)\//, regex)
		path = names["path"]
		case path do
			nil -> Glayu.Path.source_root
			path -> Path.join(Glayu.Path.source_root, path) 
		end
	end

end