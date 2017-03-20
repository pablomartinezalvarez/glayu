defmodule Glayu.Parser do
	
	def parse(md_file) do
		md = File.read! md_file
		[frontmatter|content] = String.split md, "\n---\n"
		[{'md_content', Enum.join(content, "\n")} | parse_frontmatter(frontmatter)]
	end

	defp parse_frontmatter(frontmatter) do
		List.flatten(:yamerl_constr.string frontmatter)
	end

end