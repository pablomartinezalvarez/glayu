defmodule Glayu.Template do

	def compile() do
		[layouts: compile_tpls(Glayu.Path.layouts_dir()), partials: compile_tpls(Glayu.Path.partials_dir())]
	end

	def render(layout, md_content, context, tpls) do
		base_layout = tpls[:layouts][:layout]
		inner_layout = tpls[:layouts][String.to_atom(layout)]
		# adds compiled markdown to page.content var
		page = Map.put(context[:page], :content, Earmark.as_html!(md_content)) 
		# add the copiled partials templates to the context is required by the 'partial' directive
		assigns = Enum.concat(Keyword.put(context, :page, page), [partials: tpls[:partials]])
		{inner_html, _} = Code.eval_quoted inner_layout, [assigns: assigns]
		{html, _} = Code.eval_quoted base_layout, [assigns: Enum.concat(assigns, [inner: inner_html])]
		html
	end

	defp compile_tpls(base_path) do
		Enum.map(File.ls!(base_path), fn(file) -> 
			compiled = EEx.compile_file(Path.join(base_path, file), []) 
			[name|_] = String.split(file, ".")
			{String.to_atom(name), compiled}
		end)
	end

end