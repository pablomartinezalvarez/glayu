defmodule Glayu.FrontMatter do

	def parse(frontmatter) do
		List.flatten(:yamerl_constr.string frontmatter)
	end

end