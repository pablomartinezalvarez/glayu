defmodule Glayu.Tasks.Build do

	@behaviour Glayu.Tasks.Task

	alias Glayu.Build.SiteAnalyzer
	alias Glayu.Build.TaskSpawner
	alias Glayu.Build.Store
	alias Glayu.Template

	def run(params) do
		tpls = Template.compile()
		root = root_dir(params[:regex])
		nodes = ProgressBar.render_spinner([text: "Scanning site…", done: [IO.ANSI.light_cyan, "✓", IO.ANSI.reset, " Site scan completed."], frames: :braille, spinner_color: IO.ANSI.light_cyan], fn -> 
			SiteAnalyzer.nodes(root, compile_regex(params[:regex]))
		end)
		TaskSpawner.spawn(nodes, tpls)
		{:ok, %{results: Store.get_values}}
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
		names = Regex.named_captures(~r/\/(?<path>^[^.^$*+?()[{\|]*$)\//, regex)
		path = names["path"]
		case path do
			nil -> Glayu.Path.source_root
			path -> Path.join(Glayu.Path.source_root, path) 
		end
	end

end