defmodule Glayu.Templates.Post do

	def tpl(title) do
		"""
    	---
    	title: #{title}
    	date: #{Glayu.Date.date}
    	---

    	New Glayu post
    	"""
	end

end