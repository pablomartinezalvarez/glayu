defmodule Glayu.Tasks.Build do

	alias Glayu.Build.SiteAnalyzer
	alias Glayu.Build.TaskSpawner

	def run(params) do
		"./"
		|> SiteAnalyzer.nodes
		|> TaskSpawner.spawn
		|> print_report
	end

	defp print_report(results) do
		IO.puts inspect results
	end


end