defmodule Glayu.Templates.Page do

	def tpl(title) do
		"""
    	---
    	title: #{title}
    	date: #{Glayu.Date.now}
    	---
    	A new Glayu page
    	"""
	end

end