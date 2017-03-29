defmodule Glayu.Layout do

	def load(template) do
		template
		|> Glayu.Path.layout
		|> File.read!
	end

end